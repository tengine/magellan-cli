# -*- coding: utf-8 -*-
require "magellan/cli"

require 'openssl'

module Magellan
  module Cli
    module Ssl

      DEFAULT_MAX_RETRY_COUNT = (ENV["MAGELLAN_CLI_MAX_RETRY_COUNT"] || 10).to_i

      # SSLエラー発生時に規定の回数までリトライします
      # @param name [String] エラー発生時に標準エラー出力に出力する文字列。処理の名前を想定しています。
      # @param [Hash] options オプション
      # @option options [Integer] :max_retry_count 最大リトライ回数。指定がない場合は MAGELLAN_CLI_MAX_RETRY_COUNT から、それも無ければ固定値10が使用されます。
      # @option options [Numeric] :interval リトライ時のインターバルの秒数。デフォルトは0.2秒。
      def retry_on_ssl_error(name, options = {})
        max_retry_count = (options[:max_retry_count] || DEFAULT_MAX_RETRY_COUNT).to_i
        interval = options[:interval] || 0.2
        retry_count = 0
        begin
          return yield
        rescue OpenSSL::SSL::SSLError => e
          $stderr.puts("retrying #{name} [#{e.class.name}] #{e.message}")
          sleep(interval)
          retry_count += 1
          retry if retry_count <= max_retry_count
          raise e
        end
      end
      module_function :retry_on_ssl_error

    end
  end
end
