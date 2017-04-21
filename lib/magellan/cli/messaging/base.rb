require "magellan/cli/messaging"

require 'libmagellan'
require 'json'
require 'yaml'

module Magellan
  module Cli
    module Messaging
      class Base < Magellan::Cli::Base
        include Magellan::Cli::FileAccess

        no_commands do
          def core
            @core ||= build_core
          end

          private

          def load_selection!(name, &block)
            return http_access{ load_selection(name, &block) }
          end

          def find(klass, id = nil)
            id ||= load_selection!(klass.parameter_name)["id"]
            r = get_json("/admin/#{klass.resource_key}/#{id}.json")
          end

          DEFAULT_MAGELLAN_HTTP_SERVER_URL = "https://nebula-001a-web.magellanic-clouds.net".freeze
          DEFAULT_MAGELLAN_MQTT_SERVER_HOST = "nebula-001a-mqtt.magellanic-clouds.net".freeze
          DEFAULT_MAGELLAN_MQTT_SERVER_PORT = 1883

          def build_core
            proj = find(Resources::Project)
            client_version = load_selection!(Resources::ClientVersion.parameter_name)["version"]
            options = {
              consumer_key: proj["consumer_key"],
              consumer_secret: proj["consumer_secret"],
              client_version: client_version,
              mqtt_host: ENV["MAGELLAN_MQTT_SERVER_HOST"] || DEFAULT_MAGELLAN_MQTT_SERVER_HOST,
              mqtt_port: ENV["MAGELLAN_MQTT_SERVER_PORT"] || DEFAULT_MAGELLAN_MQTT_SERVER_PORT,
              verbose: verbose?,
            }
            uri = ENV["MAGELLAN_HTTP_SERVER_URL"] || DEFAULT_MAGELLAN_HTTP_SERVER_URL
            log_verbose("HTTP URL    : #{uri.inspect}")
            log_verbose("HTTP options: #{options.inspect}")
            Libmagellan::Core.new(uri, options)
          end

          def try_reading_file(value)
            return nil if value.nil?
            if File.readable?(value)
              return File.read(value)
            else
              return value
            end
          end

          def try_reading_hash(value)
            return nil if value.nil?
            obj =
              if File.readable?(value)
                case File.extname(value)
                when ".json" then JSON.parse(File.read(value))
                when ".yml"  then YAML.load_file(value)
                else raise "Unsupported file type: #{value.inspect}, .json and .yml are supported."
                end
              else
                JSON.parse(value)
              end
            raise "#{value.inspect} contains #{obj.class.name} but it must be a Hash" unless obj.is_a?(Hash)
            return obj
          end

        end

      end
    end
  end
end
