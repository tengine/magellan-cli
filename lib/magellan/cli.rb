require "magellan/cli/version"
require "magellan/cli/i18n"

module Magellan
  module Cli
    autoload :Command  , "magellan/cli/command"

    autoload :Base     , "magellan/cli/base"
    autoload :Direct   , "magellan/cli/direct"
    autoload :Resources, "magellan/cli/resources"

    autoload :Http     , "magellan/cli/http"
    autoload :Ssl      , "magellan/cli/ssl"

    autoload :Messaging, "magellan/cli/messaging"

    autoload :Error     , "magellan/cli/errors"
    autoload :LoginError, "magellan/cli/errors"

    autoload :FileAccess, "magellan/cli/file_access"
    JSON_HEADER = {
      "Content-Type" => "application/json"
    }.freeze

    autoload :GemUpdate, "magellan/cli/gem_update"

    # CloudsqlInstance looks like one of resources,
    # but this class use gcloud command instead of magellan-api.
    autoload :CloudsqlInstance, "magellan/cli/cloudsql_instance"

    class << self
      attr_accessor :last_result
    end

  end
end
