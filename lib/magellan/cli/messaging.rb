require "magellan/cli"

module Magellan
  module Cli
    module Messaging

      autoload :Base, "magellan/cli/messaging/base"
      autoload :Http, "magellan/cli/messaging/http"
      # autoload :Spdy, "magellan/cli/messaging/spdy"
      autoload :Mqtt, "magellan/cli/messaging/mqtt"

      MAPPING = {
        "Http" => "http",
        "Mqtt" => "mqtt",
      }
    end
  end
end
