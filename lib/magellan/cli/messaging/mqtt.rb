require "magellan/cli/messaging"

module Magellan
  module Cli
    module Messaging
      class Mqtt < Magellan::Cli::Messaging::Base

        desc "pub TOPIC PAYLOAD", I18n.t(:pub, scope: [:messaging, :mqtt])
        def pub(topic, payload)
          core.publish(topic, try_reading_file(payload).dup)
          log_success "\e[32mOK\e[0m"
        rescue Magellan::Cli::Error
          raise
        rescue => e
          show_error_and_exit1(e)
        end

        desc "get [TOPIC]", I18n.t(:get, scope: [:messaging, :mqtt])
        def get(topic = nil)
          topic, payload = *core.get_message(topic)
          $stderr.puts topic
          $stdout.puts payload.ascii_only? ? payload : payload.inspect
        rescue Magellan::Cli::Error
          raise
        rescue => e
          show_error_and_exit1(e)
        end

      end
    end
  end
end
