# -*- coding: utf-8 -*-
require "magellan/cli"

require 'json'
require 'yaml'
require 'active_support/core_ext/string/inflections'

module Magellan
  module Cli
    module Resources

      autoload :Base             , "magellan/cli/resources/base"
      autoload :Organization     , "magellan/cli/resources/organization"
      autoload :Team             , "magellan/cli/resources/team"
      autoload :Project          , "magellan/cli/resources/project"
      autoload :Stage            , "magellan/cli/resources/stage"
      autoload :ClientVersion    , "magellan/cli/resources/client_version"
      autoload :Authority        , "magellan/cli/resources/authority"

      autoload :TransactionRouter, "magellan/cli/resources/transaction_router"
      autoload :Worker           , "magellan/cli/resources/worker"

      autoload :Image            , "magellan/cli/resources/image"
      autoload :Container        , "magellan/cli/resources/container"

      autoload :Cloudsql, "magellan/cli/resources/cloudsql"

      autoload :Deletable, "magellan/cli/resources/deletable"


      MAPPING =\
      {
        "Organization"  => "organization",
        "Team"          => "team",
        "Project"       => "project",
        "Authority"     => "authority",
        "Stage"         => "stage",
        "ClientVersion" => "client_version",
        #"TransactionRouter" => "tr",
        "Worker"        => "worker",
        "Image"         => "image",
        "Container"     => "container",
        "Cloudsql"      => "cloudsql",
        # "CloudsqlInstance" => "cloudsql_instance", # This is not a resource
      }

      class << self
        def concrete_classes
          @concrete_classes ||= MAPPING.keys.map{|c| self.const_get(c) }
        end

        def dependants_on(klass)
          name = klass.name.split(/::/).last
          res_name = MAPPING[name] or raise "unknown class named #{klass.name}"
          concrete_classes.select{|c| c.respond_to?(:resource_dependency) &&c.resource_dependency && !!c.resource_dependency[res_name] }
        end
      end

    end
  end
end
