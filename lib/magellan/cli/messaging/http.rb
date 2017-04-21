require "magellan/cli/messaging"

module Magellan
  module Cli
    module Messaging
      class Http < Magellan::Cli::Messaging::Base

        desc "ping", I18n.t(:ping, scope: [:messaging, :http])
        def ping
          res = core.ping
          puts_res(res)
        end

        COMMAND_ORDER = %w[get post put patch delete ping]

        [:get, :delete].each do |m|
          desc "#{m} PATH", I18n.t(m, scope: [:messaging, :http])
          method_option :headers, aliases: "-H", desc: I18n.t(:headers, scope: [:messaging, :http, :common_options])
          module_eval(<<-EOM, __FILE__, __LINE__ + 1)
            def #{m}(path)
              res = core.request(path, :#{m}, nil, try_reading_hash(options[:headers]) || {})
              puts_res(res)
            end
          EOM
        end

        [:post, :put, :patch].each do |m|
          desc "#{m} PATH", I18n.t(m, scope: [:messaging, :http])
          method_option :body   , aliases: "-d", desc: I18n.t(:body   , scope: [:messaging, :http, :common_options])
          method_option :headers, aliases: "-H", desc: I18n.t(:headers, scope: [:messaging, :http, :common_options])
          module_eval(<<-EOM, __FILE__, __LINE__ + 1)
            def #{m}(path)
              res = core.request(path, :#{m}, try_reading_file(options[:body]), try_reading_hash(options[:headers]) || {})
              puts_res(res)
            end
          EOM
        end

        no_commands do
          def puts_res(res)
            color = (res.code =~ /\A2\d\d\z/) ? "32" : "31"
            puts "\e[#{color}m#{res.body}\e[0m"
          end
        end

      end
    end
  end
end
