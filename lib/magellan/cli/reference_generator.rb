require 'magellan/cli'

require 'fileutils'

module Magellan
  module Cli
    class ReferenceGenerator

      def initialize(options = {})
        @dest = options[:dest] || "doc"
        @subdir = options[:subdir] || "."
        @io = $stdout
      end

      def run
        @shell = Thor::Shell::Basic.new
        change_global_var_temporarily(["$PROGRAM_NAME", "magellan-cli"]) do
          k = Magellan::Cli::Command
          process(k, "index.md")
          Magellan::Cli::Resources::MAPPING.each do |class_name, name|
            klass = Magellan::Cli::Resources.const_get(class_name)
            process(klass, "resources/#{name}.md", name)
          end
          name = "cloudsql_instance"
          process(Magellan::Cli::CloudsqlInstance, "#{name}.md", name)
          Magellan::Cli::Messaging::MAPPING.each do |class_name, name|
            klass = Magellan::Cli::Messaging.const_get(class_name)
            process(klass, "messaging/#{name}.md", name)
          end
        end
      end

      def change_global_var_temporarily(*tuples, &block)
        if tuples.empty?
          block.call if block
        else
          gvar_name, value = *tuples.shift
          backup = eval(gvar_name)
          begin
            eval("#{gvar_name} = value")
            change_global_var_temporarily(*tuples, &block)
          ensure
            eval("#{gvar_name} = backup")
          end
        end
      end

      def process(klass, filename, name = nil)
        if cmd = klass.all_commands["help"]
          cmd.description = I18n.t(:help, scope: [:base, :cmd])
        end

        rel_path = File.join(@subdir, filename)
        path = File.expand_path(rel_path, @dest)
        FileUtils.mkdir_p(File.dirname(path))
        instance = klass.new
        open(path, "w") do |f|
          f.puts "---"
          f.puts "layout: index"
          version = Magellan::Cli::VERSION.split(/\./)[0,2].join(".")
          f.puts "title: " << [name, "magellan-cli-#{version} (#{I18n.locale})", "Reference"].compact.join(" | ")
          lang_links = I18n.available_locales.map do |locale|
            (locale == I18n.locale) ? locale.to_s :
              begin
                path = rel_path.sub(/\/#{I18n.locale}\//, "/#{locale}/").sub(/\.md\z/, ".html")
                %!<a href="/#{path}">#{locale}</a>!
              end
          end
          f.puts %!breadcrumb: <a href="/">Top</a> / <a href="/reference">Reference</a> / <a href="/reference/magellan-cli/#{I18n.locale}">magellan-cli-#{version}</a> / #{name} #{lang_links.join(' ')}!
          f.puts "sidemenu: sidemenu/reference/magellan-cli/sidemenu-#{I18n.locale}"
          f.puts "---"
          f.puts

          f.puts "## "<< I18n.t(:commands, scope: :reference)
          f.puts
          klass.sorted_commands.each do |cmd|
            rel_path =
              Magellan::Cli::Resources::MAPPING.values.include?(cmd.name) ? "./resources/#{cmd.name}.html" :
                Magellan::Cli::Messaging::MAPPING.values.include?(cmd.name) ? "./messaging/#{cmd.name}.html" :
                  cmd.name == "cloudsql_instance" ? "./#{cmd.name}.html" :
                  "##{cmd.name}"
            f.puts "- [%s](%s)" % [Thor.send(:banner, cmd, false, false), rel_path]
          end
          f.puts

          f.puts "## " << I18n.t(:global_options, scope: :reference)
          f.puts
          change_global_var_temporarily(["$stdout", f], ["$stderr", f]) do
            f.puts "```text"
            klass.send(:print_options, @shell, klass.class_options.values)
            f.puts "```"
            f.puts
          end
          f.puts

          f.puts "## " << I18n.t(:details, scope: :reference)
          klass.sorted_commands.each do |cmd|
            next if Magellan::Cli::Resources::MAPPING.values.include?(cmd.name)
            next if Magellan::Cli::Messaging::MAPPING.values.include?(cmd.name)
            next if cmd.name == "cloudsql_instance"
            f.puts "### <a name=\"#{cmd.name}\"></a>#{cmd.name}"
            f.puts
            f.puts "```text"
            f.puts Thor.send(:banner, cmd)
            f.puts "```"
            f.puts
            unless cmd.options.empty?
              change_global_var_temporarily(["$stdout", f], ["$stderr", f]) do
                f.puts "```text"
                  klass.send(:print_options, @shell, cmd.options.values)
                f.puts "```"
                f.puts
              end
            end
            if cmd.long_description
              f.puts cmd.long_description
            else
              f.puts cmd.description
            end
            f.puts
          end

        end
      end

    end
  end
end
