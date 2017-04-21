# -*- coding: utf-8 -*-
require "magellan/cli"

module Magellan
  module Cli
    class Direct < ::Magellan::Cli::Base

      desc "get PATH", "Send GET request with PATH"
      def get(path)
        r = get_json(path)
        $stdout.puts(JSON.pretty_generate(r))
      end

      desc "post PATH [PARAMS]", "Send POST request with PATH and PARAMS"
      def post(path, params = nil)
        post_json(path)
      end

      desc "put PATH [PARAMS]", "Send PUT request with PATH and PARAMS"
      def put(path, params = nil)
        put_json(path)
      end

      desc "delete PATH", "Send DELETE request with PATH"
      def delete(path)
        delete(path)
      end

    end
  end
end
