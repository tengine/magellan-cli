# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Resources::Project do
  before{ FileUtils.cp(File.expand_path("../../../../.magellan-cli.original", __FILE__), ENV["MAGELLAN_CLI_CONFIG_FILE"]) }

  let(:base_url){ "https://localhost:3000" }
  before{ allow(Magellan::Cli::Http).to receive(:base_url).and_return(base_url) }
  let(:httpclient){ double(:httpclient) }
  let(:res){ double(:res, status: 200, body: {}.to_json) }

  let(:cmd){ Magellan::Cli::Resources::Project.new }

  before do
    allow(cmd.http_conn).to receive(:httpclient).and_return(httpclient)
    allow(cmd.http_conn).to receive(:check_login_auth!)
    allow(cmd.http_conn).to receive(:login_auth).and_return({})
  end

  describe :list do
    it do
      url = "#{base_url}/admin/project.json?%s=%s&%s=%s" % [CGI.escape("f[organization][6][o]"), "is", CGI.escape("f[organization][6][v]"), 1]
      expect(httpclient).to receive(:get).with(url).and_return(res)
      expect($stdout).to receive(:puts)
      cmd.list
    end

    let(:org_res_body){ [{id:8,name:"test1",email:"",creator_id:4,created_at:"2015-02-18T14:27:16.000Z",updated_at:"2015-02-18T14:27:16.000Z",max_project_count:1,max_team_count:100}] }
    let(:org_res){ double(:org_res, status: 200, body: org_res_body.to_json) }
    let(:list_res_body){ [{id:9,organization_id:8,default_nebula_id:2,name:"Project1",icon_url:nil,consumer_key:"test1.Project1",consumer_secret:"a5etckpurpy0od3keo25iw77mtllo2fb",created_at:"2015-02-18T14:27:21.000Z",updated_at:"2015-02-18T14:27:21.000Z",max_stage_count:2}] }
    let(:list_res){ double(:res, status: 200, body: list_res_body.to_json) }
    it do
      buf = StringIO.new
      $stdout, backup = buf, $stdout
      begin
        url = "#{base_url}/admin/project.json?%s=%s&%s=%s" % [CGI.escape("f[organization][7][o]"), "is", CGI.escape("f[organization][7][v]"), 1]
        expect(httpclient).to receive(:get).with(url).and_return(list_res)
        expect(httpclient).to receive(:get).with(%{#{base_url}/admin/magellan~auth~organization.json?compact=true}).and_return(org_res)
        cmd.list
        buf.rewind
        output = buf.read
        expect(output).to_not match /not found/
        expect(output).to match /test1/
      ensure
        $stdout = backup
      end
    end
  end

  describe :show do
    it do
      allow(res).to receive(:body).and_return("{}")
      allow(res).to receive(:status).and_return(200)
      expect(httpclient).to receive(:get).with("#{base_url}/admin/project/1.json").and_return(res)
      expect($stdout).to receive(:puts)
      cmd.show(1)
    end

    it "not authorized" do
      allow(res).to receive(:body).and_return('{"message":"You are not authorized to access this page."}')
      allow(res).to receive(:status).and_return(404)
      expect(httpclient).to receive(:get).with("#{base_url}/admin/project/1.json").and_return(res)
      expect{
        cmd.show(1)
      }.to raise_error(Magellan::Cli::Error, "You are not authorized to access this project.")
    end
  end

  describe :delete do
    before do
      @name = "dummyproject"
    end
    context "organization selected" do
      before do
        Magellan::Cli::FileAccess.update_selections(Magellan::Cli::FileAccess.load_selections.merge("magellan_auth_organization" => { id: 1, name: @name}))
        allow(res).to receive(:body).and_return("")
        allow(res).to receive(:status).and_return(401)
        expect(httpclient).to receive(:get).and_return(res)
      end
      it "show not found error message" do
        expect do
          cmd.delete(@name)
        end.to raise_error(Magellan::Cli::Resources::NotFound)
      end
    end
    context "organization not selected" do
      before do
        Magellan::Cli::FileAccess.update_selections(Magellan::Cli::FileAccess.load_selections.merge("magellan_auth_organization" => nil))
      end
      it "show not selected error message" do
        expect do
          cmd.delete(@name)
        end.to raise_error(Magellan::Cli::FileAccess::NotSelected)
      end
    end
  end
end
