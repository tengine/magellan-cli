# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Team < Base
        include Deletable

        self.resource_key = "magellan~auth~team"
        self.resource_dependency = { "organization" =>  Organization.parameter_name }
        self.field_associations = {"organization_id" => {name: "organization", class: "Organization"} }

        desc "create NAME ROLE", I18n.t(:create, scope: [:resources, :team, :cmd], resource_name: resource_name)
        def create(name, role)
          unless %w{ reader admin }.include?(role)
            raise "ROLE should be 'reader' or 'admin'"
          end
          o = load_selection!(Organization)
          params = {
            parameter_name => {
              "organization_id" => o["id"],
              "name" => name,
              "role" => role,
            }
          }
          post_json("/admin/#{self.resource_key}/new.js", params)
          select(name)
        end

=begin
        desc "invite EMAIL", I18n.t(:invite, scope: [:resources, :team, :cmd], resource_name: resource_name)
        def invite(email)
          o = load_selection!(self.class)
          params = {
            "email" => email
          }
          post_json("/admin/#{self.resource_key}/#{o["id"]}/team_invite.json", params)
        end
=end
      end

    end
  end
end
