# -*- coding: utf-8 -*-
require "magellan/cli/resources"
require 'cgi'

module Magellan
  module Cli
    module Resources

      class Stage < Base
        include Deletable

        self.resource_key = "stage~title"
        self.resource_dependency = {"project" => Project.parameter_name}
        self.hidden_fields = %w[nebula_id created_at updated_at].map(&:freeze).freeze
        self.field_associations = {"project_id" => {name: "project", class: "Project"} }

        VERSION_RESOURCE_KEY = "stage~version".freeze
        VERSION_PARAMETER_NAME = "stage_version".freeze

        desc "create NAME [-t development|staging|production]", I18n.t(:create, scope: [:resources, :stage, :cmd], resource_name: resource_name)
        option :t, type: :string, default: "development", desc: I18n.t(:type, scope: [:resources, :stage, :cmd_create])
        option :s, type: :string, default: "micro"      , desc: I18n.t(:size, scope: [:resources, :stage, :cmd_create])
        def create(name)
          type = options["t"]
          unless %w{ development staging production }.include?(type)
            raise "Unknown Stage Type #{type}"
          end
          size = options["s"]
          unless %w{ micro standard }.include?(size)
            raise "Unknown Stage Size #{size}"
          end
          proj = load_selection!(Project)
          params = {
            parameter_name => {
              "project_id" => proj["id"],
              "name" => name,
              "stage_type" => type,
              "stage_size" => size,
            }
          }
          post_json("/admin/#{resource_key}/new.json", params)
          select(name)
        end

        no_commands do
          def build_name_query(name)
            build_query("name" => name).update(default_query)
          end
        end

        desc "select NAME", I18n.t(:select, scope: [:resources, :common, :cmd], res_name: resource_name)
        def select(name)
          if selected = load_selections[parameter_name]
            deselect unless selected["name"] == name
          end

          q = build_name_query(name)
          r = update_first_result(parameter_name, name, "/admin/stage~title.json", q)

          # # current
          # q = build_query("title" => r["id"], "phase" => 2) # 2: current
          # update_first_result(VERSION_PARAMETER_NAME, "phase=2", "/admin/stage~version.json", q, %w[id])

          # # planning
          q = build_query("title" => r["id"], "phase" => 1) # 1: planning
          update_first_result(VERSION_PARAMETER_NAME, "phase=1", "/admin/stage~version.json", q, %w[id])
        end

        def self.deselect(selections)
          selections.delete(parameter_name)
          selections.delete(VERSION_PARAMETER_NAME)
          deselect_dependants(selections)
        end

        desc "planning", I18n.t(:planning, scope: [:resources, :stage, :cmd])
        def planning
          switch_version(1)
        end

        desc "current", I18n.t(:current, scope: [:resources, :stage, :cmd])
        def current
          switch_version(2)
        end

        no_commands do
          def switch_version(phase)
            s = load_selection!(self.class)
            q = build_query("title" => s["id"], "phase" => phase) # 1: planning, 2: current, 3: used
            update_first_result(VERSION_PARAMETER_NAME, "phase=#{phase}", "/admin/stage~version.json", q, %w[id])
          end
        end

        desc "prepare", I18n.t(:prepare, scope: [:resources, :stage, :cmd], containers_name: Container.resource_name.pluralize)
        def prepare
          s = load_selection!(self.class)
          id = s["id"]
          r = post_json("/admin/stage~title/#{id}/simple_method_call.json", {method_name: "prepare_containers"})
          Container.new.show_list(r["result"])
        end

        desc "repair", I18n.t(:repair, scope: [:resources, :stage, :cmd], resource_name: resource_name)
        def repair
          r = call_repair
          puts r["success"] ? "\e[32msucceeded to repair stage\e[0m" : "\e[31mfailed to repair stage\e[0m"
        end

        no_commands do
          def call_repair
            s = load_selection!(self.class)
            id = s["id"]
            post_json("/admin/stage~title/#{id}/simple_method_call.json", {method_name: "repair"})
          end
        end

        desc "update ATTRIBUTES", I18n.t(:update, scope: [:resources, :common, :cmd], resource_name: resource_name)
        def update(attrs)
          s = load_selection!(self.class)
          attrs = JSON.parse(File.readable?(attrs) ? File.read(attrs) : attrs)
          put_json("/admin/stage~title/#{s['id']}/edit.json", {"stage_title" => attrs})
        end

        desc "release_now", I18n.t(:release_now, scope: [:resources, :stage, :cmd])
        option :A, type: :boolean, default: false, desc: I18n.t(:async, scope: [:resources, :stage, :cmd_release_now])
        option :i, type: :numeric, default: 10, desc: I18n.t(:interval, scope: [:resources, :stage, :cmd_release_now])
        option :t, type: :numeric, default: 60 * 60, desc: I18n.t(:timeout, scope: [:resources, :stage, :cmd_release_now])
        def release_now
          spacer = "\r" << (" " * 20)
          stage = load_selection!(self.class)
          print "\rrelease starting"
          id = stage["id"]
          res0 = post_json("/admin/stage~title/#{id}/simple_method_call.json", {method_name: "release_now"})
          res1 = res0["result"]
          if res1
            print spacer
            print "\r#{res1['status']}"
          else
            print spacer
            puts "\e[31m#{res0.inspect}\e[0m"
            raise res0["message"]
          end

          return res1 if options["A"]
          res2 = get_json("/admin/release~operation.json", build_query("release_job" => res1["id"]))
          ope = res2.first
          ope_id = ope["id"]
          i = options["i"]
          Timeout.timeout(options["t"]) do
            loop do
              sleep(i)
              res3 = get_json("/admin/release~operation/#{ope_id}.json", default_query)
              st = res3["status"]
              unless res1["status"] == st
                case st
                when "executing" then
                  res4 = get_json("/admin/release~transaction.json", build_query("release_operation" => ope_id))
                  total = res4.length
                  complete = res4.select{ |r| r["status"] == "completed" }.length
                  print spacer
                  print "\rProgress: %2d /%2d" % [complete, total]
                when "completed"
                  print spacer
                  puts "\r#{st}"
                  reload
                  return
                when "aborted" then
                  print spacer
                  puts "\rrelease #{st}"
                  puts "now repairing stage automatically..."
                  r = call_repair
                  puts r["success"] ? "succeeded to repair stage. try `stage release_now` again after fix" : "\e[31mfailed to repair stage\e[0m"
                  raise Magellan::Cli::Error, "release #{st}"
                end
              end
            end
          end
        end

        desc "logs", I18n.t(:logs, scope: [:resources, :stage, :cmd], workers_name: Worker.resource_name.pluralize)
        def logs
          s = load_selection!(self.class)
          id = s["id"]
          obj = get_json("/admin/stage~title/#{id}/logs.json")
          if obj["value"]
            obj["value"].each do |log|
              puts "#{Time.at(log["time"].to_f).strftime("%Y-%m-%d %H:%M:%S")}:#{log["version"]}:#{log["container"]}: #{log["message"]}"
            end
          end
        end

        desc "set_container_num NUM", I18n.t(:set_container_num, scope: [:resources, :stage, :cmd], containers_name: Container.resource_name.pluralize, image_name: Image.resource_name)
        def set_container_num(num)
          s = load_selection!(self.class)
          v = load_selection!(VERSION_PARAMETER_NAME)
          i = load_selection!(Image)
          post_json("/admin/stage~version/#{v["id"]}/set_container_num.json", { container_num: num, container_image_id: i["id"] })
        end

        desc "reload", I18n.t(:reload, scope: [:resources, :stage, :cmd])
        def reload
          s = load_selection!(self.class)
          select(s["name"])
          [Worker, Image, Container].each do |klass|
            s = (load_selections || {})[klass.parameter_name]
            next unless s
            name = s["name"]
            next unless name
            klass.new.select(name)
          end
        end
      end

    end
  end
end
