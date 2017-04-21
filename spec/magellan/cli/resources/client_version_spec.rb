# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Resources::ClientVersion do

  let(:cmd){ Magellan::Cli::Resources::ClientVersion.new }

  let(:http_conn){ double(:http_conn, :check_login_auth! => nil) }
  before{ allow(cmd).to receive(:http_conn).and_return(http_conn) }

  describe :list do
    before do
      expect(cmd).to receive(:get_json).and_return([{id: 1, project_id: 1, stage_title_id: 1, version: "1.0.0", url_mapping_yaml: nil, status: "1" }])
      expect($stdout).to receive(:puts)
    end
    it do
      cmd.list
    end
  end

  describe :create do
    describe :success do
      let(:client_version_list_response) { [ { "id" => 1, "version" => "1.1.0" } ] }
      before do
        allow(cmd).to receive(:load_selections).and_return({Magellan::Cli::Resources::Project.parameter_name => {"id" => 1, "name" => "ProjectA"}, Magellan::Cli::Resources::Stage.parameter_name => {"id" => 1, "name" => "StageA"} })
        expect(cmd).to receive(:post_json).with("/admin/client_version/new.json", { "client_version" => { "project_id" => 1, "stage_title_id" => 1, "version" => "1.1.0" } })
        # TODO: stub in details
        # expect(cmd).to receive(:get_json).with(any_args).and_return(client_version_list_response)
        # expect(cmd).to receive(:update_selections).with("client_version" => { "id" => 1, "version" => "1.0.0" })
      end
      it do
        cmd.create("1.1.0")
      end
    end

    describe :success_with_domain do
      before do
        allow(cmd).to receive(:load_selections).and_return({Magellan::Cli::Resources::Project.parameter_name => {"id" => 1, "name" => "ProjectA"}, Magellan::Cli::Resources::Stage.parameter_name => {"id" => 1, "name" => "StageA"} })
        expect(cmd).to receive(:post_json).with("/admin/client_version/new.json", { "client_version" => { "project_id" => 1, "stage_title_id" => 1, "version" => "1.1.0", "domain" => "foo.example.com" } })
      end
      it do
        cmd.options = {domain: "foo.example.com"}
        cmd.create("1.1.0")
      end
    end

    describe :error do
      context "stage not selected" do
        before do
          expect(cmd).to receive(:load_selections).and_return({})
        end
        it do
          expect{
            cmd.create("1.1.0")
          }.to raise_error(Magellan::Cli::FileAccess::NotSelected)
        end
      end
    end
  end

  describe :update do
    let(:selections) do
      {
        Magellan::Cli::Resources::Project.parameter_name => {"id" => 1, "name" => "ProjectA"},
        Magellan::Cli::Resources::ClientVersion.parameter_name => {"id" => 1, "version" => "Sandbox1"},
        Magellan::Cli::Resources::Stage.parameter_name => {"id" => 1, "name" => "Stage1"},
      }
    end
    describe :success_to_update_domain do
      before do
        allow(cmd).to receive(:load_selections).and_return(selections)
        expect(cmd).to receive(:put_json).with("/admin/client_version/1/edit.json", { "client_version" => { "domain" => "bar.example.com" } })
      end
      it do
        cmd.update('{"domain": "bar.example.com"}')
      end
    end

    describe :success_to_update_stage do
      let(:st_id){ 2 }
      let(:st_name){ "Stage2" }
      before do
        allow_any_instance_of(Magellan::Cli::Resources::Stage).to receive(:http_conn).and_return(http_conn)
        allow_any_instance_of(Magellan::Cli::Resources::Stage).to receive(:load_selections).and_return(selections)
        allow(cmd).to receive(:load_selections).and_return(selections)
        expect(http_conn).to receive(:get_json).with("/admin/stage~title.json", {"f[name][1][o]"=>"is", "f[name][1][v]"=>st_name, "f[project][2][o]"=>"is", "f[project][2][v]"=>1}).
                              and_return([{"id" => st_id, "name" => st_name}])
        expect(cmd).to receive(:put_json).with("/admin/client_version/1/edit.json", { "client_version" => { "stage_title_id" => st_id } })
      end
      it do
        cmd.update('{"stage": "Stage2"}')
      end
    end

  end

end
