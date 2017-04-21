# -*- coding: utf-8 -*-
require "magellan/cli/resources"
require "magellan/cli/file_access"

require 'json'
require 'yaml'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/object/blank'

require 'text-table'

module Magellan
  module Cli
    module Resources

      class NotFound < Magellan::Cli::Error
      end

      class Base < ::Magellan::Cli::Base
        include Magellan::Cli::FileAccess

        no_commands do

          def load_selection!(name, &block)
            return http_access{ load_selection(name, &block) }
          end
          def update_selections!(hash = nil, &block)
            return http_access{ update_selections(hash, &block) }
          end

          def build_query(hash)
            @@no ||= 0
            r = {}
            hash.each do |key, value|
              @@no += 1
              r["f[#{key}][#{@@no}][o]"] = "is"
              r["f[#{key}][#{@@no}][v]"] = value
            end
            return r
          end

          def default_query
            http_access do |cli|
              sel = load_selections
              q = {}
              (self.class.resource_dependency || {}).each do |f, res|
                r = sel[res]
                raise NotSelected, I18n.t(:not_selected, scope: [:resources, :base, :default_query], label: f) unless r
                q[f] = r["id"]
              end
              build_query(q)
            end
          end

          def get_first_result!(resource_name, name, path, query)
            results = get_json(path, query)
            raise NotFound, I18n.t(:not_found, scope: [:resources, :base, :get_first_result], resource_name: resource_name, name: name) if results.blank? || results.first.blank?
            results.first
          end

          def update_first_result(resource_name, name, path, query, fields = nil)
            fields ||= ["id", self.class.caption_attr].compact
            r = get_first_result!(resource_name, name, path, query)
            obj = fields.each_with_object({}) do |f, d|
              d[f] = r[f]
            end
            update_selections!(resource_name => obj)
            return r
          end

          def association_map(fields)
            associations = {}
            (self.class.field_associations || {}).each do |f, obj|
              i = fields.index(f)
              next unless i
              fields[i] = obj[:name]
              res = obj[:resource] || ((k = Resources.const_get(obj[:class])) ? k.resource_key : nil)
              res2 = get_json("/admin/#{res}.json", {"compact" => true})
              attr_name = (k ? k.caption_attr : nil) || "caption"
              associations[f] = res2.each_with_object({}){|r,d| d[ r["id"].to_i ] = r[attr_name] || r["label"] }
            end
            return associations
          end

          def association_get(associations, r, f)
            v = r[f]
            m = associations[f]
            m ? m[v] || (v.nil? ? "" : "(not found: #{v.inspect})") : v
          end

          DEFAULT_HIDDEN_FIELDS = %w[created_at updated_at].map(&:freeze).freeze


          def query_list
            get_json("/admin/#{self.class.resource_key}.json"){ default_query }
          end
          private :query_list

          def list
            res1 = query_list
            Magellan::Cli.last_result = res1
            show_list(res1)
          end

          def show_list(res1)
            return $stdout.puts("Total: 0") if res1.nil? or res1.empty?

            t = Text::Table.new
            original_fields =
              res1.map(&:keys).flatten.uniq -
              (self.class.hidden_fields || DEFAULT_HIDDEN_FIELDS) -
              (self.class.multiline_fields || [])

            fields = original_fields.dup
            fields.unshift(" ")
            associations = association_map(fields)
            t.head = fields
            t.rows = []
            selected_id = (load_selections[ parameter_name ] || {})["id"]
            res1.each do |r|
              row = original_fields.map do |f|
                if self.class.filtered_fields and self.class.filtered_fields[f.to_s]
                  self.class.filtered_fields[f.to_s].call(r[f])
                else
                  association_get(associations, r, f)
                end
              end
              row.unshift(r["id"] == selected_id ? "*" : " ")
              t.rows << row
            end
            # $stdout.puts(JSON.pretty_generate(res1) << "\nTotal: #{res1.length}")
            $stdout.puts(t.to_s << "\nTotal: #{res1.length}")
          end

          def show(id = nil)
            id ||= load_selection!(self.class.parameter_name)["id"]
            r = get_json("/admin/#{self.class.resource_key}/#{id}.json")
            Magellan::Cli.last_result = r
            t = Text::Table.new
            t.head = ["field", "value"]

            table_fields = r.keys - (self.class.multiline_fields || [])
            associations = association_map(table_fields.dup)
            table_fields.each do |f|
              if self.class.filtered_fields and self.class.filtered_fields[f.to_s]
                t.rows << [f, self.class.filtered_fields[f.to_s].call(r[f])]
              else
                t.rows << [f, association_get(associations, r, f)]
              end
            end
            $stdout.puts t.to_s

            (self.class.multiline_fields || []).each do |f|
              $stdout.puts "\n"
              $stdout.puts " #{f} ".center(50, "=")
              v = r[f]
              next unless v

              case f
              when /_json\Z/ then
                next if v.empty?
                begin
                  o = JSON.parse(v)
                  $stdout.puts(JSON.pretty_generate(o))
                rescue JSON::ParserError => e
                  $stdout.puts "\e[33m[WARN] #{e.message}\e[0m"
                  $stdout.puts v
                end
              # when /_yaml\Z/ then
              else
                $stdout.puts v
              end
            end
          end

          def select(name)
            q = build_query(self.class.caption_attr => name).update(default_query)
            update_first_result(self.class.parameter_name, name, "/admin/#{self.class.resource_key}.json", q)
            update_selections! do |s|
              self.class.deselect_dependants(s)
            end
          end

          def deselect
            update_selections! do |s|
              self.class.deselect(s)
            end
          end

          class << self
            def deselect(selections)
              selections.delete(parameter_name)
              deselect_dependants(selections)
            end

            def deselect_dependants(selections)
              classes = Resources.dependants_on(self)
              classes.each do |klass|
                klass.deselect(selections)
              end
            end
          end

          def process_error_response(res)
            obj = JSON.parse(res.body) rescue nil
            if obj and obj.is_a?(Hash) and msg = obj["message"]
              res_name = self.class.name.split(/::/).last.underscore
              msg.gsub!(/#{Regexp.escape(self.class.model_class_name)}/, res_name)
              if msg =~ /\A#{Regexp.escape(res_name)}/
                msg = "The #{msg}"
              end
              msg.gsub! /this page/, "this #{res_name}"
              fatal(msg)
            end
          end

          def self.inherited(klass)
            base_name = klass.name.split(/::/).last
            res_name = Magellan::Cli::Resources::MAPPING[base_name] or raise "resource not found for #{base_name}"

            klass.instance_eval(<<-EOM, __FILE__, __LINE__ + 1)
              def resource_name
                "#{res_name}"
              end
            EOM

            klass.module_eval(<<-EOM, __FILE__, __LINE__ + 1)
              no_commands do
                cattr_accessor :resource_key
                cattr_accessor :resource_dependency
                cattr_accessor :field_associations
                cattr_accessor :hidden_fields, :multiline_fields
                cattr_accessor :filtered_fields
                cattr_accessor :caption_attr
                self.caption_attr = "name"

                def self.parameter_name
                  resource_key.gsub(/~/, "_")
                end
                def parameter_name
                  self.class.parameter_name
                end
                def self.model_class_name
                  resource_key.split(/~/).map(&:camelize).join('::')
                end

                def self.filter_field(field, &blk)
                  @@filtered_fields ||= {}
                  @@filtered_fields[field.to_s] = blk
                end
              end

              desc "list", "#{I18n.t(:list, scope: [:resources, :common, :cmd], res_names: res_name.pluralize)}"
              def list
                super
              end

              desc "show [ID]", "#{I18n.t(:show, scope: [:resources, :common, :cmd], res_name: res_name)}"
              def show(id = nil)
                super(id)
              end

              desc "select NAME", "#{I18n.t(:select, scope: [:resources, :common, :cmd], res_name: res_name)}"
              def select(name)
                super
              end

              desc "deselect", "#{I18n.t(:deselect, scope: [:resources, :common, :cmd], res_name: res_name)}"
              def deselect
                super
              end
            EOM
          end
        end

      end

    end
  end
end
