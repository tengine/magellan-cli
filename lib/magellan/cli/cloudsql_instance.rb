# -*- coding: utf-8 -*-
require "magellan/cli/resources"

require 'logger'
require 'securerandom'

require 'logger_pipe'
require 'text-table'

module Magellan
  module Cli

      class CloudsqlInstance < ::Magellan::Cli::Base

        desc "create INSTANCE", I18n.t(:create, scope: [:resources, :cloudsql_instance, :cmd], resource_name: "CloudSQL instance")
        OPTIONS = {
          create: {
            "tier"                => {type: :string , default: "D0"        , enum: %w[D0 D1 D2 D4 D8 D16 D32]},
            "region"              => {type: :string , default: "asia-east1"},
            "activation-policy"   => {type: :string , default: "ON_DEMAND" , enum: %w[ALWAYS NEVER ON_DEMAND]},
            "skip-assign-ip"      => {type: :boolean                       },
            "authorized-networks" => {type: :string , default: "0.0.0.0/0" },
            "gce-zone"            => {type: :string , default: "asia-east1-c"},
            "pricing-plan"        => {type: :string , default: "PER_USE"   , enum: %w[PACKAGE PER_USE]},
          },
          password: {
            "password" => {aliases: "-p", type: :string},
          },
          common: {
            "account"     => {type: :string},
            "log-http"    => {type: :boolean},
            "project"     => {type: :string},
            "trace-token" => {type: :string},
            "user-output-enabled" => {type: :boolean},
            "verbosity"   => {type: :string, default: "info", enum: %w[debug info warning error critical none]},
          },
          removed: {"async" => {type: :boolean}},
          overwritten: { "format" => {type: :string, default: "json"}, }
        }
        CREATE_OPTION_SCOPE = [:resources, :cloudsql_instance, :cmd_create]
        OPTIONS.each do |cmd, options|
          options.each do |name, hash|
            method_option(name, {desc: I18n.t(name, scope: CREATE_OPTION_SCOPE)}.update(hash))
          end
        end
        def create(instance, *args)
          $stderr.puts(I18n.t(:starting_launch, scope: [:resources, :cloudsql_instance, :messages]))
          options["format"] = "json"
          create_args = build_args(options, [:common, :create])
          create_args << "--assign-ip" unless options["skip-assign-ip"]
          res1_text = gcloud("sql instances create #{instance}", create_args + args)
          res1 = res1_text.nil? ? nil : JSON.parse(res1_text)

          # p res1
          # res1
          # {
          #   "currentDiskSize"=>"281069967", "databaseVersion"=>"MYSQL_5_6", "etag"=>"\"wEP3hMpsWqL85yYiZI8N_zVwr4g/MQ\"",
          #   "instance"=>"magellan-cli-testdbi03", "instanceType"=>"CLOUDSQL_INSTANCE",
          #   "ipAddresses"=>[{"ipAddress"=>"173.194.229.107"}],
          #   "ipv6Address"=>"2001:4860:4864:1:fb5a:76f:71c1:f2f3",
          #   "kind"=>"sql#instance", "maxDiskSize"=>"268435456000", "project"=>"scenic-doodad-617",
          #   "region"=>"asia-east1",
          #   "serverCaCert"=>{...},
          #   "settings"=>{
          #     "activationPolicy"=>"ON_DEMAND",
          #     "backupConfiguration"=>[{"binaryLogEnabled"=>false, "enabled"=>false, "id"=>"2057f912-faf7-4a5d-a16d-c5a12a9dceca", "kind"=>"sql#backupConfiguration", "startTime"=>"23:00"}],
          #     "ipConfiguration"=>{"authorizedNetworks"=>["0.0.0.0/0"], "enabled"=>true, "kind"=>"sql#ipConfiguration"},
          #     "kind"=>"sql#settings",
          #     "locationPreference"=>{"kind"=>"sql#locationPreference", "zone"=>"asia-east1-c"},
          #     "pricingPlan"=>"PACKAGE", "replicationType"=>"SYNCHRONOUS", "settingsVersion"=>"1",
          #     "tier"=>"D0"
          #   },
          #   "state"=>"RUNNABLE"
          # }

          # % gcloud sql instances create magellan-cli-testdbi06 --tier=D0 --region=asia-east1 --activation-policy=ON_DEMAND --authorized-networks=0.0.0.0/0 --gce-zone=asia-east1-c  --verbosity=debug  --assign-ip
          # DEBUG: Running gcloud.sql.instances.create with Namespace(__calliope_internal_deepest_parser=ArgumentParser(prog='gcloud.sql.instances.create', usage=None, description='Creates a new Cloud SQL instance.', version=None, formatter_class=<class 'argparse.HelpFormatter'>, conflict_handler='error', add_help=False), account=None, activation_policy='ON_DEMAND', api_version=None, assign_ip=True, async=False, authorized_gae_apps=[], authorized_networks=['0.0.0.0/0'], backup=True, backup_start_time=None, cmd_func=<bound method Command.Run of <googlecloudsdk.calliope.backend.Command object at 0x10767cc50>>, command_path=['gcloud', 'sql', 'instances', 'create'], configuration=None, database_flags=None, database_version='MYSQL_5_6', document=None, enable_bin_log=None, follow_gae_app=None, format=None, gce_zone='asia-east1-c', h=None, help=None, http_timeout=None, instance='magellan-cli-testdbi06', log_http=None, master_instance_name=None, pricing_plan='PER_USE', project=None, quiet=None, region='asia-east1', replication=None, require_ssl=None, tier='D0', trace_email=None, trace_log=False, trace_token=None, user_output_enabled=None, verbosity='debug', version=None).
          # Creating Cloud SQL instance...done.
          # Created [https://www.googleapis.com/sql/v1beta3/projects/scenic-doodad-617/instances/magellan-cli-testdbi06].
          # DEBUG: Explict Display.
          # NAME                    REGION      TIER  ADDRESS          STATUS
          # magellan-cli-testdbi06  asia-east1  D0    173.194.249.189  RUNNABLE

          host = res1['ipAddresses'].first['ipAddress']
          t = Text::Table.new
          t.head = %w[NAME REGION TIER ADDRESS STATUS]
          t.rows = [[res1['instance'], res1['region'], res1['settings']['tier'], host, res1['state']]]
          $stderr.puts t.to_s

          pw_options = options.dup
          pw_options["password"] ||= SecureRandom.hex(8)
          pw_args = build_args(pw_options, [:common, :password])
          res2 = gcloud("sql instances set-root-password #{instance}", pw_args)
          # res2.inspect #=> []
          $stderr.puts "\e[32mCOMPLETE\e[0m"

          $stderr.puts I18n.t(:env_head, scope: CREATE_OPTION_SCOPE)
          env_options = {
            scope: CREATE_OPTION_SCOPE,
            mysql_host: host,
            mysql_port: 3306,
            mysql_database: "#{instance}_production",
            mysql_username: "root",
            mysql_password: pw_options["password"],
          }
          $stdout.puts I18n.t(:env_body, env_options)
          $stderr.puts I18n.t(:env_tail, scope: CREATE_OPTION_SCOPE)
        end

        desc "delete INSTANCE", I18n.t(:delete, scope: [:resources, :cloudsql_instance, :cmd], resource_name: "CloudSQL instance")
        def delete(instance, *args)
          check_gcloud_command
          system("gcloud sql instances delete #{instance} #{args.join(' ')} 2>&1")
        end

        desc "list", I18n.t(:list, scope: [:resources, :cloudsql_instance, :cmd], resource_name: "CloudSQL instance")
        def list(*args)
          check_gcloud_command
          system("gcloud sql instances list #{args.join(' ')} 2>&1")
        end

        no_commands do
          def logger
            unless @logger
              @logger = Logger.new($stderr)
              @logger.level = verbose? ? Logger::INFO : Logger::WARN
            end
            @logger
          end

          def build_args(options, commands)
            opts = options.dup
            OPTIONS[:removed].keys.each{|k| opts.delete(k)}
            cmd_keys = (commands + [:overwritten]).map{|cmd| OPTIONS[cmd].keys }.flatten
            opts.delete_if{|k,_| !cmd_keys.include?(k)}
            opts.map{|k,v| "--#{k}=#{v}"}
          end

          def gcloud(subcommand, arguments)
            check_gcloud_command
            cmd = "gcloud #{subcommand} #{arguments.join(' ')}"
            LoggerPipe.run(logger, cmd, dry_run: dryrun?, returns: :stdout, logging: :stderr)
          end

          def check_gcloud_command
            return true unless `which gcloud`.empty?
            $stderr.puts("\e[31m%s\e[0m" % I18n.t(:gcloud_not_found, scope: [:resources, :cloudsql_instance, :messages]))
            exit(1)
          end
        end

      end
  end
end
