# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Authority < Base
        self.resource_key = "magellan~auth~authority"
        self.resource_dependency = { "team" =>  Team.parameter_name }
        self.hidden_fields = %w[auth_type created_at updated_at].map(&:freeze).freeze
        self.field_associations = {"team_id" => {name: "team", class: "Team"},
                                   "auth_id" => {name: "project", class: "Project"} }

        filter_field :stage_type do |stype|
          case stype
          when 1, "1", "development"
            "development"
          when 2, "2", "staging"
            "development, staging"
          when 3..9, "3".."9", "production"
            "development, staging, production"
          else
            stype
          end
        end

        desc "update ATTRIBUTES", I18n.t(:update, scope: [:resources, :common, :cmd], resource_name: resource_name)
        def update(attrs)
          s = load_selection!(self.class)
          attrs = JSON.parse(File.readable?(attrs) ? File.read(attrs) : attrs)
          put_json("/admin/#{resource_key}/#{s['id']}/edit.json", {"magellan_auth_authority" => attrs})
        end

        desc "create PROJECT_ROLE STAGE_ROLE STAGE_TYPE", I18n.t(:create, scope: [:resources, :authority, :cmd], resource_name: resource_name)
        def create(project_role, stage_role, stage_type)
          team = load_selection!(Team)
          project = load_selection!(Project)
          unless %w{ owner admin reader }.include?(project_role)
            raise Magellan::Cli::Error, "PROJECT_ROLE must be owner/admin/reader"
          end
          unless %w{ read read_write }.include?(stage_role)
            raise Magellan::Cli::Error, "STAGE_ROLE must be read/read_write"
          end
          unless %w{ development staging production }.include?(stage_type) or /\A\d\z/ =~ stage_type
            raise Magellan::Cli::Error, "STAGE_TYPE must be development/staging/production or 0-9 (single digit)"
          end
          stage_type_map = {
            "development" => 1,
            "staging" => 2,
            "production" => 3,
          }
          (1..9).each do |i| stage_type_map[i.to_s] = i end
          params = {
            parameter_name => {
              "auth_id" => project["id"],
              "auth_type" => "Project",
              "team_id" => team["id"],
              "project_role" => project_role,
              "stage_role" => stage_role,
              "stage_type" => stage_type_map[stage_type],
            }
          }
          ret = post_json("/admin/#{resource_key}/new.json", params)
          if ret and ret["id"]
            select ret["id"]
          end
        end

        desc "select ID", I18n.t(:select, scope: [:resources, :authority, :cmd], resource_name: resource_name)
        def select(id)
          q = build_query("id" => id)
          update_first_result(self.class.parameter_name, id, "/admin/#{resource_key}.json", q)
          update_selections! do |s|
            self.class.deselect_dependants(s)
          end
        end

        desc "delete ID", I18n.t(:delete, scope: [:resources, :authority, :cmd], resource_name: resource_name)
        def delete(id)
          q = build_query("id" => id).update(default_query)
          r = get_first_result!(self.class.resource_name, id, "/admin/#{resource_key}.json", q)
          super("/admin/#{resource_key}/#{r['id']}/delete.json")
          log_success("OK")
        end
      end
    end
  end
end
