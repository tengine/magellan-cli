# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Organization < Base
        include Deletable

        self.resource_key = "magellan~auth~organization"
        # self.field_associations = {"creator_id" => {name: "creator", class: "User"} }

        desc "create NAME", I18n.t(:create, scope: [:resources, :common, :cmd], resource_name: resource_name)
        def create(name)
          params = {
            parameter_name => {
              "name" => name,
            }
          }
          post_json("/admin/#{self.resource_key}/new.json", params)
          select(name)
        end
      end

    end
  end
end
