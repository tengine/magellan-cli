# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class TransactionRouter < Base
        self.resource_key = "functions~transaction_router"
        self.resource_dependency = {"stage" => Stage.parameter_name}

        desc "create NAME", I18n.t(:create, scope: [:resources, :common, :cmd], resource_name: resource_name)
        def create(name)
          s = load_selection!(Stage::VERSION_PARAMETER_NAME)
          params = {
            self.class.parameter_name => {
              "stage_version_id" => s["id"],
              "name" => name,
            }
          }
          post_json("/admin/#{self.resource_key}/new.js", params)
          select(name)
        end

      end

    end
  end
end
