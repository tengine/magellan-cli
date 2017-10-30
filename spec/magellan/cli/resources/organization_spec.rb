# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Resources::Organization do

  let(:cmd){ Magellan::Cli::Resources::Organization.new }

  let(:http_conn){ double(:http_conn, :check_login_auth! => nil) }
  before{ allow(cmd).to receive(:http_conn).and_return(http_conn) }

  describe :list do
    before do
      expect(cmd).to receive(:get_json).and_return([{id: 1, name: "org1", creator_id: 1}])
      expect($stdout).to receive(:puts)
    end
    it do
      cmd.list
    end
  end

  describe :create do
    let(:organization_list_response) { [ { "id" => 1, "name" => "new1" } ] }
    before do
      expect(cmd).to receive(:post_json).with("/admin/magellan~auth~organization/new.js", {"magellan_auth_organization" => { "name" => "new1" }})
      allow(cmd).to receive(:get_json).with(any_args).and_return(organization_list_response)
    end
    it do
      cmd.create("new1")
    end
  end

  describe :delete do
    let(:org_id){ 5 }
    let(:org_name){ "org5" }
    let(:organization_list_response) { [ { "id" => org_id, "name" => org_name } ] }
    before do
      allow(http_conn).to receive(:get_json).with("/admin/magellan~auth~organization.json", {"f[name][5][o]"=>"is", "f[name][5][v]"=> org_name}).and_return(organization_list_response)
      allow(http_conn).to receive(:delete).with("/admin/magellan~auth~organization/5/delete.json")
    end
    it do
      cmd.delete(org_name)
    end
  end

end
