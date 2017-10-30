# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Worker < Base

        self.resource_key = "functions~worker"
        self.resource_dependency = {"stage" => Stage::VERSION_PARAMETER_NAME}
        self.hidden_fields = %w[created_at updated_at].map(&:freeze).freeze
        self.multiline_fields = %w[migration_command_1 migration_command_2 run_command environment_vars_yaml].map(&:freeze).freeze
        self.field_associations = {"stage_version_id" => {name: "stage", resource: "stage~version"} }

        desc "create NAME IMAGE", I18n.t(:create, scope: [:resources, :worker, :cmd], resource_name: resource_name)
        method_option :attributes_yaml, aliases: "-A", desc: I18n.t(:attributes_yaml, scope: [:resources, :worker, :cmd_create])
        "path to YAML file which defines attributes"
        def create(name, image_name)
          s = load_selection!(Stage::VERSION_PARAMETER_NAME)
          attrs =
            if path = options[:attributes_yaml]
              YAML.load_file(path)
            else
              {}
            end
          params = {
            "functions_worker" => {
              "stage_version_id" => s["id"],
              "name" => name,
              "image_name" => image_name,
            }.update(attrs)
          }
          post_json("/admin/#{self.resource_key}/new.js", params)
          select(name)
        end

        desc "update ATTRIBUTES", I18n.t(:update, scope: [:resources, :worker, :cmd], resource_name: resource_name)
        def update(attrs)
          if File.readable?(attrs)
            attrs = YAML.load_file(attrs)
          else
            attrs = JSON.parse(attrs)
          end
          w = load_selection!(self.class)
          self.class.hidden_fields.each do |f| attrs.delete(f) end
          self.class.field_associations.keys.each do |f| attrs.delete(f) end
          params = {
            parameter_name => attrs
          }
          put_json("/admin/#{resource_key}/#{w["id"]}/edit.js", params)
          if v = attrs[self.class.caption_attr]
            select(v)
          end
        end

        desc "prepare_images", I18n.t(:prepare_images, scope: [:resources, :worker, :cmd], images_name: Image.resource_name.pluralize, worker_name: Worker.resource_name)
        def prepare_images
          s = load_selection!(Worker)
          id = s["id"]
          r = post_json("/admin/functions~worker/#{id}/simple_method_call.json", {method_name: "prepare_images"})
          targets = r["result"].select{|i| i["instance_amount"] > 0 }
          if targets.length == 1
            img = r["result"].first
            Image.new.select(img["name"])
          end
          Image.new.show_list(r["result"])
        end

      end

    end
  end
end
