# -*- coding: utf-8 -*-
require "magellan/cli/resources"

module Magellan
  module Cli
    module Resources

      module Deletable

        def self.included(klass)
          klass.module_eval do

            desc "delete NAME", I18n.t(:delete, scope: [:resources, :common, :cmd], resource_name: resource_name)
            def delete(name)
              q = build_query("name" => name).update(default_query)
              r = get_first_result!(self.class.resource_name, name, "/admin/#{resource_key}.json", q)
              super("/admin/#{resource_key}/#{r['id']}/delete.json")
              log_success("OK")
            end

          end
        end

      end

    end
  end
end
