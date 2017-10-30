# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      class Cloudsql < Base
        include Deletable

        self.resource_key = "cloudsql~database"
        self.resource_dependency = {"stage" => Stage.parameter_name}
        self.hidden_fields = %w[cloudsql_instance_id].map(&:freeze).freeze

        desc "create NAME", I18n.t(:create, scope: [:resources, :common, :cmd], resource_name: "#{resource_name} database")
        option :A, type: :boolean, default: false, desc: I18n.t(:async, scope: [:resources, :cloudsql, :cmd_create])
        option :i, type: :numeric, default: 10, desc: I18n.t(:interval, scope: [:resources, :cloudsql, :cmd_create])
        option :t, type: :numeric, default: 600, desc: I18n.t(:timeout, scope: [:resources, :cloudsql, :cmd_create])
        def create(name)
          o = load_selection!(Stage)
          params = {
            parameter_name => {
              "stage_title_id" => o["id"],
              "name" => name,
            }
          }
          res0 = post_json("/admin/#{resource_key}/new.js", params)
          select(name)

          return res0 if options["A"]

          id = load_selection!(parameter_name)["id"]
          interval = options["i"]
          Timeout.timeout(options["t"]) do
            loop do
              sleep(interval)
              res1 = get_json("/admin/#{resource_key}/#{id}.json")
              return res1 if res1["available"]
            end
          end
        end

      end
    end
  end
end
