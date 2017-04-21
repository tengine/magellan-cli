require "pry"

if ENV["COVERAGE"] =~ /true|yes|on|1/i
  require "simplecov"
  require 'simplecov-rcov'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter
  ]
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'magellan/cli'

ENV["MAGELLAN_CLI_CONFIG_FILE"] = File.expand_path("../.magellan-cli", __FILE__)
I18n.locale = :en
