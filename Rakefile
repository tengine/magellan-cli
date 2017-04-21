# coding: utf-8
# bundler が thor をまるごと抱えているという恐ろしい状態で、
# 暫定修正版である groovenauts-thorの修正が反映されない事態が発生していましたが、
# ここで先にrequireすればサブコマンドのhelpも正しく動くのでひとまずこのまま行きます。
# bundler・・・
# https://github.com/bundler/bundler/tree/master/lib/bundler/vendor
require 'thor'
require 'thor/command'

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

module Bundler
  class GemHelper
    def version_tag
      d = File.basename(File.dirname(__FILE__))
      "#{d}/#{version}"
    end
  end
end

langs = %w[en ja]

namespace :reference do
  langs.each do |lang|
    desc "generate reference in #{lang}, options: DEST, SUBDIR"
    task lang.to_sym do
      require "magellan/cli/reference_generator"
      ENV["LANG"] = lang
      I18n.locale = lang.to_sym
      gen = Magellan::Cli::ReferenceGenerator.new(dest: ENV["DEST"] || ".", subdir: ENV['SUBDIR'] || "reference/#{lang}")
      gen.run
    end
  end

  desc "generate reference for devcenter"
  task :devcenter do
    dest = ENV["DEST"] ||= File.expand_path("../../../magellan-devcenter.github.io/content", __FILE__)
    raise "directory not found: #{dest}"  unless Dir.exist?(dest)
    langs.each do |lang|
      ENV["SUBDIR"] = "reference/magellan-cli/#{lang}"
      system("bundle exec rake reference:#{lang}")
    end
  end
end
 
desc "generate reference in #{langs.join(', ')}, options: DEST, SUBDIR"
# 本当はこんなふうに書けると嬉しいけど、一度ロードされたクラスを
# LANGを変更して再ロードするのはしんどいので、別のプロセスで実行します
# task :reference => langs.map{|lang| :"reference:#{lang}"}
task :reference do
  langs.each{|lang| system("bundle exec rake reference:#{lang}")}
end

Rake::Task[:build].enhance([:reference])
