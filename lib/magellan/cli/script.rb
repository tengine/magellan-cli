require 'magellan/cli'

require 'shellwords'

module Magellan::Cli
  module Script
    SETTINGS = [:io, :prompt, :program_name]
    class << self
      attr_accessor *SETTINGS
    end
    self.io = $stdout
    self.prompt = "[CLI] "
    self.program_name = "magellan-cli"

    SETTINGS.each do |name|
      module_eval("def #{name}; Magellan::Cli::Script.#{name}; end")
    end

    def cli(args, options = {})
      args = Shellwords.split(args) if args.is_a?(String)
      args << "-V" if ARGV.include?("-V")
      $PROGRAM_NAME, backup = program_name, $PROGRAM_NAME
      self.io.puts "#{prompt}#{$PROGRAM_NAME} #{args.join(' ')}"
      begin
        Magellan::Cli::Command.start(args) do |e|
          exit(1) unless e.message =~ options[:allow]
        end
      ensure
        $PROGRAM_NAME = backup
      end
    end
    module_function :cli

  end
end

include Magellan::Cli::Script
