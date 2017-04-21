# -*- coding: utf-8 -*-
require "magellan/cli"

require 'httpclient/webagent-cookie' # it should be required before httpclient to prevent using http-cookie.gem
require 'httpclient'
require 'json'
require 'uri'
require 'nokogiri'

require 'active_support/core_ext/hash/keys'

module Magellan
  module Cli
    class Http
      include Magellan::Cli::FileAccess

      DEFAULT_HTTP_PORT  = (ENV['DEFAULT_HTTP_PORT' ] ||  80).to_i
      DEFAULT_HTTPS_PORT = (ENV['DEFAULT_HTTPS_PORT'] || 443).to_i

      attr_reader :cmd
      attr_reader :httpclient
      attr_reader :base_url

      attr_reader :auth_token
      attr_reader :login_auth

      def self.base_url
        @base_url ||= (ENV["MAGELLAN_SITE"] || "https://api-asia.magellanic-clouds.com")
      end

      # Magellan::Cli::Httpのコンストラクタです。
      #
      # @param [String] base_url_or_host 接続先の基準となるURLあるいはホスト名
      # @param [Hash] options オプション
      # @option options [String]  :api_version APIのバージョン。デフォルトは "1.0.0"
      def initialize(cmd)
        @cmd = cmd
        base_url_or_host = self.class.base_url
        if base_url_or_host =~ URI.regexp
          @base_url = base_url_or_host.sub(/\/\Z/, '')
          uri = URI.parse(@base_url)
        else
          if config_path = search_file(".magellan-cli.yml")
            config = YAML.load_file_with_erb(config_path)
            options = config[base_url_or_host.to_s].deep_symbolize_keys
          else
            options = {}
          end
          uri = URI::Generic.build({scheme: "http", host: base_url_or_host, port: DEFAULT_HTTP_PORT}.update(options))
          @base_url = uri.to_s
        end

        @httpclient = HTTPClient.new
        @httpclient.debug_dev = ColorDebugDev.new($stderr) if cmd.verbose?
        @httpclient.ssl_config.verify_mode = nil # 自己署名の証明書をOKにする
        @login_auth = load_selections["login"]
      end

      class ColorDebugDev
        def initialize(dev)
          @dev = dev
        end
        def <<(msg)
          @dev << "\e[34m#{msg}\e[0m"
        end
      end

      def debug_lf
        r = yield if block_given?
        @httpclient.debug_dev << "\n" if @httpclient.debug_dev
        r
      end


      def login_form_url
        @login_form_url ||= base_url + "/users/sign_in.html"
      end
      def login_url
        @login_url ||= base_url + "/api/sign_in.json"
      end

      def check_login_auth!
        auth = login_auth
        if auth.nil? || auth.empty?
          raise Magellan::Cli::Error, I18n.t(:not_logged_in, scope: [:login, :check_login_auth], command: File.basename($0))
        end
      end

      # magellan-apiサーバに接続してログインの検証とアクセストークンの保存を行います。
      #
      # @return [boolean] login成功/失敗
      def api_login!(email, password)
        @auth_token ||= get_auth_token
        params = {
          "user" => {
            "email" => email,
            "password" => password
          },
          "authenticity_token" => @auth_token
        }.to_json
        res2 = Ssl.retry_on_ssl_error("login"){ debug_lf{ @httpclient.post(login_url, params, JSON_HEADER) } }

        case res2.status
        when 200...300 then logined = true
        else logined = false
        end

        if logined
          body = JSON.parse res2.body
          write_login_info!(email, body["token"])
        else
          reset_login_info!
        end
        logined
      end

      def api_login_by_token!(email, token)
        url = "#{base_url}/admin/magellan~auth~organization.json"
        params = {"email" => email, "token" => token}
        res = debug_lf{ httpclient.get(url, params) }

        logined =
          case res.status
          when 200...400 then true
          else false
          end

        if logined
          write_login_info!(email, token)
        else
          reset_login_info!
        end
        logined
      end


      def write_login_info!(email, token)
        update_selections("login" => {"email" => email, "token" => token })
      end

      def reset_login_info!
        update_selections("login" => nil)
      end

      def get_auth_token
        res = Ssl.retry_on_ssl_error("login_form"){ debug_lf{ @httpclient.get(login_form_url) } }
        case res.status
        when 200
          doc = Nokogiri::HTML.parse(res.body, login_form_url, res.body_encoding.to_s)
          node = doc.xpath('//input[@name="authenticity_token"]').first
          unless node
            raise Cli::Error.new("fail to login Magellan")
          end
          node.attribute('value').value
        when 503
          begin
            obj = JSON.parse(res.body)
            if obj and obj["message"]
              err_message = obj["message"]
            else
              err_message = "Under Maintenance"
            end
          rescue
            err_message = "Under Maintenance"
          end
          raise Cli::Error.new("Under Maintenance")
        else
          raise Cli::Error.new("fail to login Magellan")
        end
      end

      # @httpclient.inspectの戻り値の文字列が巨大なので、inspectで出力しないようにします。
      def inspect
        r = "#<#{self.class.name}:#{self.object_id} "
        fields = (instance_variables - [:@httpclient]).map{|f| "#{f}=#{instance_variable_get(f).inspect}"}
        r << fields.join(", ") << ">"
      end

      def search_file(basename)
        dirs = [".", "./config", ENV['HOME']].join(",")
        Dir["{#{dirs}}/#{basename}"].select{|path| File.readable?(path)}.first
      end
      private :search_file


      def check_response(res)
        case res.status
        when 200...400 then
          begin
            r = JSON.parse(res.body)
          rescue
            # DELETE で 302 Found を返す時に HTML がレンダリングされることがあるので
            # status code 300 台では JSON パースエラーを無視する
            if res.status >= 300
              return nil
            end
            raise
          end
          r
        else
          cmd.process_error_response(res)
        end
      end

      # ログインしてGETします
      # @param [String] rel_path cli.base_url からの相対パス
      # @param [Hash] params クエリ文字列
      # @return [Object] レスポンスのBODYをJSONとしてパースした結果オブジェクト
      def get_json(rel_path, params = {})
        url = "#{base_url}#{rel_path}"
        params.update(yield) if block_given?
        params = login_auth.merge(params)
        if params && !params.empty?
          url << '?' << params.map{|k,v| "%s=%s" % [CGI.escape(k.to_s), CGI.escape(v.to_s)] }.join("&")
        end
        # "Unknown key: max-age = 0" というメッセージを表示させないために$stderrを一時的に上書き
        $stderr, bak = StringIO.new, $stderr
        res = nil
        begin
          res = debug_lf{ httpclient.get(url) }
        ensure
          $stderr = bak
        end
        check_response(res)
      end

      # ログインしてPOSTします
      # @param [String] rel_path cli.base_url からの相対パス
      # @param [Hash] params POSTで渡されるパラメータ
      # @return nil
      def post(rel_path, params)
        params = login_auth.update(params || {})
        process_res(:post, rel_path, params)
      end

      # ログインしてJSON形式のbodyをPOSTします
      # @param [String] rel_path cli.base_url からの相対パス
      # @param [Hash] params POSTで渡されるパラメータ
      # @return nil
      def post_json(rel_path, params)
        params = login_auth.update(params || {})
        process_res(:post, rel_path, params.to_json, JSON_HEADER)
      end

      # ログインしてPUTします
      # @param [String] rel_path cli.base_url からの相対パス
      # @param [Hash] params PUTで渡されるパラメータ
      # @return nil
      def put(rel_path, params)
        params = login_auth.update(params || {})
        process_res(:put, rel_path, params)
      end

      # ログインしてJSON形式のbodyをPUTします
      # @param [String] rel_path cli.base_url からの相対パス
      # @param [Hash] params PUTで渡されるパラメータ
      # @return nil
      def put_json(rel_path, params)
        params = login_auth.update(params || {})
        process_res(:put, rel_path, params.to_json, JSON_HEADER)
      end

      # ログインしてDELETEします
      # @param [String] rel_path cli.base_url からの相対パス
      # @return nil
      def delete(rel_path)
        params = login_auth
        process_res(:delete, rel_path, params.to_json, JSON_HEADER)
      end

      def process_res(http_method, rel_path, *args)
        url = "#{base_url}#{rel_path}"
        res = debug_lf{ httpclient.send(http_method, url, *args) }
        check_response(res)
      end

    end
  end
end
