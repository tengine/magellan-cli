# coding: utf-8
require "magellan/cli"

require 'thor'

module Magellan
  module Cli
    class Base < Thor
      class_option :version, type: :boolean, aliases: "-v", desc: I18n.t(:version, scope: [:base, :class_option])
      class_option :verbose, type: :boolean, aliases: "-V", desc: I18n.t(:verbose, scope: [:base, :class_option])
      class_option :dryrun , type: :boolean, aliases: "-D", desc: I18n.t(:dryrun , scope: [:base, :class_option])

      no_commands do

        def sub(klass)
          task = klass.new
          task.options = self.options
          task
        end

        def opts
          @opts ||= options || {}
        end

        def dryrun?
          opts[:dryrun]
        end

        def verbose?
          opts[:verbose]
        end

        def log_verbose(msg)
          self.class.log_verbose(msg) if verbose?
        end

        def log_info(msg)
          self.class.log_info(msg)
        end
        def log_warning(msg)
          self.class.log_warning(msg)
        end
        def log_success(msg)
          self.class.log_success(msg)
        end
        def log_error(msg)
          self.class.log_error(msg)
        end

        def fatal(msg)
          log_verbose(caller.join("\n  "))
          raise Cli::Error, msg
        end

        def show_error_and_exit1(e)
          log_error "[#{e.class}] #{e.message}"
          log_verbose("  " << e.backtrace.join("\n  "))
          exit(1)
        end

        def http_conn
          @http_conn ||= Cli::Http.new(self)
        end

        def login!(email, password)
          logined = http_conn.api_login!(email, password)
          if logined
            log_success I18n.t(:success, scope: [:http, :login])
          else
            log_error I18n.t(:error, scope: [:http, :login])
            exit(1)
          end
        end

        def login_by_token!(email, token)
          logined = http_conn.api_login_by_token!(email, token)
          if logined
            log_success I18n.t(:success, scope: [:http, :token])
          else
            log_error I18n.t(:error, scope: [:http, :token])
            exit(1)
          end
        end

        def http_access
          if block_given?
            http_conn.check_login_auth!
            return yield(http_conn)
          else
            return log_success(I18n.t(:ok, scope: [:http, :access_api]))
          end
        end


        # ログインしてGETします
        # @param [String] rel_path http.base_url からの相対パス
        # @param [Hash] params クエリ文字列
        # @return [Object] レスポンスのBODYをJSONとしてパースした結果オブジェクト
        def get_json(rel_path, params = {}, &block)
          http_access do |api|
            api.get_json(rel_path, params, &block)
          end
        end

        # ログインしてPOSTします
        # @param [String] rel_path http.base_url からの相対パス
        # @param [Hash] params POSTで渡されるパラメータ
        # @return nil
        def post(rel_path, params, &block)
          http_access do |api|
            api.post(rel_path, params, &block)
          end
        end

        # ログインしてJSON形式のbodyをPOSTします
        # @param [String] rel_path http.base_url からの相対パス
        # @param [Hash] params POSTで渡されるパラメータ
        # @return nil
        def post_json(rel_path, params, &block)
          http_access do |api|
            api.post_json(rel_path, params, &block)
          end
        end

        # ログインしてPUTします
        # @param [String] rel_path http.base_url からの相対パス
        # @param [Hash] params PUTで渡されるパラメータ
        # @return nil
        def put(rel_path, params, &block)
          http_access do |api|
            api.put(rel_path, params, &block)
          end
        end

        # ログインしてJSON形式のbodyをPUTします
        # @param [String] rel_path http.base_url からの相対パス
        # @param [Hash] params PUTで渡されるパラメータ
        # @return nil
        def put_json(rel_path, params, &block)
          http_access do |api|
            api.put_json(rel_path, params, &block)
          end
        end

        # ログインしてDELETEします
        # @param [String] rel_path http.base_url からの相対パス
        # @return nil
        def delete(rel_path, &block)
          http_access do |api|
            api.delete(rel_path, &block)
          end
        end

        def process_error_response(res)
          obj = JSON.parse(res.body) rescue nil
          if obj and obj.is_a?(Hash) and msg = obj["message"]
            fatal(msg)
          end
        end
      end



      class << self
        def puts_with_color(color_no, msg)
          $stderr.puts("\e[#{color_no}m#{msg}\e[0m")
        end

        def log_verbose(msg, flag = true)
          puts_with_color(34, msg) if flag
        end
        def log_info(msg)
          puts_with_color(0, msg)
        end
        def log_warning(msg)
          puts_with_color(33, msg)
        end
        def log_success(msg)
          puts_with_color(32, msg)
        end
        def log_error(msg)
          puts_with_color(31, msg)
        end

        def sorted_commands(all = true)
          cmd_hash = all_commands.dup
          Thor::Util.thor_classes_in(self).each do |klass|
            cmd_hash.update(klass.commands)
          end
          if order = self.const_get(:COMMAND_ORDER) rescue nil
            result = order.map{|i| cmd_hash[i]}
            result += (cmd_hash.keys - order).map{|i| cmd_hash[i]}
          else
            result = cmd_hash.values
          end
          if idx = result.index{|cmd| cmd.name == "help" }
            h = result.delete_at(idx)
            result << h
          end
          return result
        end

        def sorted_printable_commands(all = true, subcommand = false)
          list = printable_commands(all, subcommand)
          Thor::Util.thor_classes_in(self).each do |klass|
            list += klass.printable_commands(false)
          end
          order = self.const_get(:COMMAND_ORDER) rescue nil
          if order
            orig = list
            list = order.map do |ptn|
              idx = orig.index{|t| t.first =~ /\b#{ptn}\b/}
              raise "#{ptn} not found" unless idx
              orig.delete_at(idx)
            end
            list += orig # add items not in COMMAND_ORDER
          end
          # # don't sort in alphabetical order
          # list.sort! { |a, b| a[0] <=> b[0] }

          # move help to the end of list
          if idx = list.index{|t| t.first =~ /\bhelp\b/ }
            h = list.delete_at(idx)
            list << h
          end
          return list
        end

        def update_common_help_message
          if cmd = all_commands["help"]
            cmd.description = I18n.t(:help, scope: [:base, :cmd])
          end
        end

        # overwrite Thor.help method
        def help(shell, subcommand = false)
          update_common_help_message
          if defined?(@package_name) && @package_name
            shell.say "#{@package_name} commands:"
          else
            shell.say "Commands:"
          end

          shell.print_table(sorted_printable_commands(true, subcommand), :indent => 2, :truncate => true)
          shell.say
          class_options_help(shell)
        end

        # override Thor.command_help
        def command_help(shell, command_name)
          meth = normalize_command_name(command_name)
          command = all_commands[meth]
          handle_no_command_error(meth) unless command

          shell.say "Usage:"
          shell.say "  #{banner(command)}"
          shell.say
          class_options_help(shell, nil => command.options.map { |_, o| o })
          if command.long_description
            shell.say "Description:"
            shell.print_wrapped(command.long_description, :indent => 2)
          else
            shell.say command.description
          end
        end

      end

    end
  end
end
