require "magellan/cli"

require 'thor'
require 'active_support/core_ext/string/inflections'

module Magellan
  module Cli
    class Command < Base
      include Magellan::Cli::FileAccess

      class << self
        # override Thor::Base.start method
        def start(given_args = ARGV, config = {})
          Magellan::Cli::FileAccess.ensure_config_dir
          verbose = ARGV.include?("-V") || ARGV.include?("--verbose")
          # class_options verbose and version are defined in Magellan::Cli::Base
          if (ARGV == ["-v"] || ARGV == ["--version"])
            log_info(File.basename($0) << " " << Magellan::Cli::VERSION)
            exit(0)
          elsif ARGV.include?("-v") || ARGV.include?("--version")
            log_info(File.basename($0) << " " << Magellan::Cli::VERSION)
          end
          begin
            GemUpdate.search do |name, v|
              log_info("\n\e[32mNew version available. try `gem install #{name} -v #{v}`\e[0m\n")
            end
          rescue => e
            log_verbose("[#{e.class}] #{e.message}", verbose)
          end
          begin
            super(given_args, config)
          rescue Magellan::Cli::Error => e
            log_error(e.message)
            block_given? ? yield(e) : exit(1)
          rescue => e
            log_error("[#{e.class}] #{e.message}")
            log_verbose("  " << e.backtrace.join("\n  "), verbose)
            block_given? ? yield(e) : exit(1)
          end
        end

        # overwrite Magellan::Cli::Base.help method
        def help(shell, subcommand = false)
          super(shell, subcommand)

          shell.say
          shell.say "RESOURCES:"
          shell.say "  " << Resources::MAPPING.keys.join(", ")
          shell.say "  " << I18n.t(:for_more_detail, scope: [:command, :cmd_help], command: File.basename($0))
          shell.say
        end
      end

      Resources::MAPPING.each do |classname, name|
        desc "#{name} SUBCOMMAND ...ARGS", I18n.t(:manage_resource, scope: [:command, :cmd], resource: name.pluralize)
        subcommand name, ::Magellan::Cli::Resources.const_get(classname)
      end

      desc "cloudsql_instance SUBCOMMAND ...ARGS", I18n.t(:manage_resource, scope: [:command, :cmd], resource: "cloudsql_instances")
      subcommand "cloudsql_instance", ::Magellan::Cli::CloudsqlInstance

      Messaging::MAPPING.each do |classname, name|
        desc "#{name} SUBCOMMAND ...ARGS", I18n.t(name.to_sym, scope: [:command, :cmd, :messaging])
        subcommand name, ::Magellan::Cli::Messaging.const_get(classname)
      end

      COMMAND_ORDER = %w[login] + Resources::MAPPING.values + %w[cloudsql_instance] + Messaging::MAPPING.values

      #desc "direct SUBCOMMAND ...ARGS", "Send request directly"
      #subcommand "direct", ::Magellan::Cli::Direct

      desc "login", I18n.t(:login, scope: [:command, :cmd])
      method_option :email,    aliases: "-e", desc: I18n.t(:email, scope: [:command, :cmd_login])
      method_option :password, aliases: "-p", desc: I18n.t(:password, scope: [:command, :cmd_login])
      method_option :authentication_token,    aliases: "-t", desc: I18n.t(:authentication_token, scope: [:command, :cmd_login])
      def login
        unless email = options[:email]
          print "email: "
          email = STDIN.gets.strip
        end

        password = options[:password]
        token    = options[:authentication_token]

        if password.blank? && token.blank?
          log_warning I18n.t(:warning, scope: :login)
          print "password: "
          password = STDIN.noecho(&:gets).chomp
          puts ""
        end

        if password.blank? && token.blank?
          print "authentication_token: "
          token = STDIN.noecho(&:gets).chomp
          puts ""
        end

        result =
          if password.present?
            login!(email, password)
          else
            login_by_token!(email, token)
          end

        select_single_resources
        result
      end

      desc "info", I18n.t(:info, scope: [:command, :cmd])
      def info
        http_conn.check_login_auth!
        selections = load_selections || {}
        d = {"user" => http_conn.login_auth["email"] }
        Resources::MAPPING.each do |classname, name|
          klass = ::Magellan::Cli::Resources.const_get(classname)
          attr = klass.caption_attr
          if val = selections[ klass.parameter_name ]
            d[name] = val[attr] ? val[attr] : val.inspect
          end
        end
        log_info YAML.dump(d)
      end

      no_commands do

        def select_single_resources
          %w[Organization Project ClientVersion Stage Worker Image Cloudsql].each do |class_name|
            klass = Magellan::Cli::Resources.const_get(class_name)
            cmd = klass.new
            res = cmd.send(:query_list)
            if res.length == 1
              value = res.first[klass.caption_attr]
              cmd.select(value)
            else
              break
            end
          end
        end

      end
    end
  end
end
