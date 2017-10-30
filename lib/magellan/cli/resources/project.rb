# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Project < Base
        include Deletable

        self.resource_key = "project"
        self.resource_dependency = { "organization" =>  Organization.parameter_name }
        self.hidden_fields = %w[default_nebula_id created_at updated_at].map(&:freeze).freeze
        self.field_associations = {"organization_id" => {name: "organization", class: "Organization"} }

        desc "update ATTRIBUTES", I18n.t(:update, scope: [:resources, :common, :cmd], resource_name: resource_name)
        def update(attrs)
          s = load_selection!(self.class)
          attrs = JSON.parse(File.readable?(attrs) ? File.read(attrs) : attrs)
          put_json("/admin/project/#{s['id']}/edit.js", {"project" => attrs})
        end

        desc "create NAME", I18n.t(:create, scope: [:resources, :common, :cmd], resource_name: resource_name)
        def create(name)
          o = load_selection!(Organization)
          params = {
            parameter_name => {
              "organization_id" => o["id"],
              "name" => name,
            }
          }
          post_json("/admin/#{resource_key}/new.js", params)
          select(name)
        end
      end

    end
  end
end
