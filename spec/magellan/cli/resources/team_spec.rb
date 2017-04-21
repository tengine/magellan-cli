# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Resources::Team do

  let(:cmd){ Magellan::Cli::Resources::Team.new }

  let(:http_conn){ double(:http_conn, :check_login_auth! => nil) }
  before{ allow(cmd).to receive(:http_conn).and_return(http_conn) }

  describe :list do
    before do
      expect(cmd).to receive(:get_json).and_return([{id: 1, organization_id: 1, name: "team1" }])
      expect($stdout).to receive(:puts)
    end
    it do
      cmd.list
    end
  end

  describe :create do
    describe :success do
      let(:team_list_response) { [{"id" => 1, "name" => "team1"}] }
      before do
        allow(cmd).to receive(:load_selections).and_return({ Magellan::Cli::Resources::Organization.parameter_name => {"id" => 1, "name" => "org1"}})
        expect(cmd).to receive(:post_json).with("/admin/magellan~auth~team/new.json", { "magellan_auth_team" => { "organization_id" => 1, "name" => "team1", "role" => role } })
        # TODO: stub in details...
        allow(cmd).to receive(:get_json).with(any_args).and_return(team_list_response)
        allow(cmd).to receive(:get_json).with(any_args).and_return(team_list_response)
      end
      context "role=reader" do
        let(:role){ "reader" }
        it do
          cmd.create("team1", role)
        end
      end
      context "role=admin" do
        let(:role){ "admin" }
        it do
          cmd.create("team1", role)
        end
      end
    end
    describe :error do
      context "role=owner" do
        let(:role){ "owner" }
        it do
          expect{
            cmd.create("team1", role)
          }.to raise_error(RuntimeError, /ROLE should be/)
        end
      end
    end
  end

  describe :delete do
    let(:team_id){ 5 }
    let(:team_name){ "team99" }
    let(:team_list_response) { [ { "id" => team_id, "name" => team_name } ] }
    before do
      expected_params = {
        "f[name][15][o]"=>"is",
        "f[name][15][v]"=> team_name,
        "f[organization][16][o]"=>"is",
        "f[organization][16][v]"=>1
      }
      allow(http_conn).to receive(:get_json).with("/admin/magellan~auth~team.json", expected_params).and_return(team_list_response)
      allow(http_conn).to receive(:delete).with("/admin/magellan~auth~team/5/delete.json")
    end
    it do
      cmd.delete(team_name)
    end
  end

end
