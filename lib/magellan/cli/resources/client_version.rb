# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class ClientVersion < Base
        self.resource_key = "client_version"
        self.resource_dependency = {"project" => "project"}

        self.hidden_fields = %w[project_id created_at updated_at].map(&:freeze).freeze
        self.field_associations = {
          "stage_title_id" => {name: "stage", class: "Stage"},
        }
        self.caption_attr = "version"

        desc "create VERSION", I18n.t(:create, scope: [:resources, :client_version, :cmd], resource_name: resource_name)
        method_option :domain, aliases: "-d", desc: I18n.t(:domain, scope: [:resources, :client_version, :cmd_create])
        def create(version)
          project = load_selection!(Project)
          stage = load_selection!(Stage)
          attrs = {
            "project_id" => project["id"],
            "stage_title_id" => stage["id"],
            "version" => version,
          }
          if d = options[:domain]
            attrs["domain"] = d
          end
          params = { parameter_name => attrs }
          post_json("/admin/#{resource_key}/new.js", params)
          # TODO implement select method
          # select(version)
        end

        desc "update ATTRIBUTES", I18n.t(:update, scope: [:resources, :client_version, :cmd], resource_name: resource_name)
        def update(attrs)
          if File.readable?(attrs)
            attrs = YAML.load_file(attrs)
          else
            attrs = JSON.parse(attrs)
          end
          stage_name = attrs.delete("stage")

          cv = load_selection!(self.class)
          self.class.hidden_fields.each do |f| attrs.delete(f) end
          self.class.field_associations.keys.each do |f| attrs.delete(f) end

          unless stage_name.blank?
            q = Stage.new.build_name_query(stage_name)
            r = get_first_result!(Stage.parameter_name, stage_name, "/admin/stage~title.json", q)
            attrs["stage_title_id"] = r["id"]
          end

          params = {
            parameter_name => attrs
          }
          put_json("/admin/#{resource_key}/#{cv["id"]}/edit.js", params)
        end

        desc "delete VERSION", I18n.t(:delete, scope: [:resources, :client_version, :cmd], resource_name: resource_name)
        def delete(version)
          q = build_query("version" => version).update(default_query)
          r = get_first_result!(self.class.resource_name, version, "/admin/#{resource_key}.json", q)
          super("/admin/#{resource_key}/#{r['id']}/delete.json")
          log_success("OK")
        end

        desc "select VERSION", I18n.t(:select, scope: [:resources, :client_version, :cmd], resource_name: 'client_version')
        def select(name)
          super
        end
      end

    end
  end
end
