# -*- coding: utf-8 -*-
require 'spec_helper'

describe "deselect" do
  let(:work_yaml){ File.expand_path("../../../../tmp/magellan-cli.yml", __FILE__) }
  let(:src_yaml){ File.expand_path("../magellan-cli_test.yml", __FILE__) }
  around do |example|
    FileUtils.cp(src_yaml, work_yaml)
    ENV["MAGELLAN_CLI_CONFIG_FILE"], backup = work_yaml, ENV["MAGELLAN_CLI_CONFIG_FILE"]
    begin
      example.run
    ensure
      ENV["MAGELLAN_CLI_CONFIG_FILE"] = backup
    end
  end

  stage_children = [
    Magellan::Cli::Resources::Team,
    Magellan::Cli::Resources::Worker,
    Magellan::Cli::Resources::Image,
  ].freeze

  stage_deletions = [
    Magellan::Cli::Resources::Stage.parameter_name,
    Magellan::Cli::Resources::Stage::VERSION_PARAMETER_NAME,
  ] + stage_children.map(&:parameter_name)

  project_deletions = stage_deletions + [
    Magellan::Cli::Resources::Project,
    Magellan::Cli::Resources::ClientVersion
  ].map(&:parameter_name)

  organization_deletions = project_deletions + [
    Magellan::Cli::Resources::Organization,
  ].map(&:parameter_name)

  {
    Magellan::Cli::Resources::Stage => stage_deletions,
    Magellan::Cli::Resources::Project => project_deletions,
    Magellan::Cli::Resources::Organization => organization_deletions,
  }.each do |klass, deletions|
    describe klass do
      it do
        selections = YAML.load_file(src_yaml)
        subject.deselect
        deletions.each do |key|
          selections.delete(key)
        end
        expect(YAML.load_file(work_yaml)).to eq selections
      end
    end
  end

  (
    stage_children +
    [Magellan::Cli::Resources::ClientVersion]
  ).each do |klass|
    describe klass do
      it do
        selections = YAML.load_file(src_yaml)
        subject.deselect
        selections.delete(subject.parameter_name)
        expect(YAML.load_file(work_yaml)).to eq selections
      end
    end
  end

  describe Magellan::Cli::Resources::Organization do
    context "select another one" do
      it do
        allow(subject).to receive(:get_json).
          with("/admin/magellan~auth~organization.json", an_instance_of(Hash)).
          and_return([{"id" => 5, "name" => "test3"}])
        expect(YAML.load_file(work_yaml)).to include(Magellan::Cli::Resources::Project.parameter_name)
        subject.select "test3"
        expect(YAML.load_file(work_yaml)).to_not include(Magellan::Cli::Resources::Project.parameter_name)
      end
    end
  end

end
