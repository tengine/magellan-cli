require "magellan/cli"

require 'time'
require 'thor'
require 'active_support/core_ext/string/inflections'

module Magellan
  module Cli

    module GemUpdate
      LAST_UPDATE_SEARCHED_AT = "last_update_searched_at".freeze
      UPDATE_SEARCH_INTERVAL = 1 * 24 * 60 * 60 # 1 day

      class << self

        def search
          t = FileAccess.load_selections[LAST_UPDATE_SEARCHED_AT]
          return nil if t && (Time.now < Time.parse(t) + UPDATE_SEARCH_INTERVAL)
          name = "magellan-cli"
          version = `gem search -r #{name} -q --no-details --versions`.scan(/\((.*)\)/).flatten.first
          FileAccess.update_selections({LAST_UPDATE_SEARCHED_AT => Time.now.to_s})
          if version
            curr = Gem::Version.new(Magellan::Cli::VERSION)
            last = Gem::Version.new(version)
            if last > curr
              yield(name, version) if block_given?
              return version
            else
              # puts "#{curr} is newer than equal #{last}"
            end
          else
            # puts "no gem version found for #{name}"
          end
          return nil
        end

      end
    end

  end
end
