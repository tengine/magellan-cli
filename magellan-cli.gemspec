# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magellan/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "magellan-cli"
  spec.version       = Magellan::Cli::VERSION
  spec.authors       = ["akm2000"]
  spec.email         = ["t-akima@groovenauts.jp"]
  spec.summary       = %q{commandline tools for magellanic cloud service.}
  spec.description   = %q{commandline tools for magellanic cloud service.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httpclient", "~> 2.5"
  spec.add_runtime_dependency "groovenauts-thor"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "activesupport", "~> 4.1.4"
  spec.add_runtime_dependency "text-table", "~> 1.2.3"
  spec.add_runtime_dependency "i18n"
  spec.add_runtime_dependency "psych", ">= 2.0.0", "<= 2.0.8"
  spec.add_runtime_dependency "libmagellan", "~> 0.2.4"
  spec.add_runtime_dependency "logger_pipe", "~> 0.3.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
