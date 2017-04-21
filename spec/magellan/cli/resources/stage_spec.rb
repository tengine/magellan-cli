# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Resources::Stage do

  let(:cmd){ Magellan::Cli::Resources::Stage.new }

  let(:http_conn){ double(:http_conn, :check_login_auth! => nil) }
  before{ allow(cmd).to receive(:http_conn).and_return(http_conn) }

  let(:proj1_json) do
    {"id" => 1, "label" => "DefaultProject1"}
  end
  let(:stage1_json) do
    {
      "id" => 1, "project_id" => 1, "nebula_id" => 1, "name" => "DefaultStage1",
      "stage_size" => "1",
      "stage_type" => "1",
      "status" => "1", "authentication" => true,
      "created_at" => "2015-08-13T08:39:21.000Z", "updated_at" => "2015-08-13T08:39:21.000Z",
      "max_worker_count" => 1, "max_container_count" => 5, "container_num" => 0,
      "release_job_status" => nil,
      "last_released_at" => nil, "can_update" => true, "can_delete" => true
    }
  end

  describe :list do
    before do
      expect(cmd).to receive(:get_json).with("/admin/stage~title.json").and_return([stage1_json])
      expect(cmd).to receive(:get_json).with("/admin/project.json", {"compact"=>true}).and_return([proj1_json])
      expect($stdout).to receive(:puts)
    end
    it do
      cmd.list
    end
  end

  describe :create do
    let(:stage_name){ "Stage2" }
    let(:organization_list_response) { [ { "id" => 1, "label" => "Stage1" } ] }
    before do
      expect(cmd).to receive(:post_json).
        with("/admin/stage~title/new.json", {"stage_title" => {"project_id"=>1,"name"=>stage_name, "stage_type"=>"development", "stage_size"=>"standard" }})
      allow(cmd).to receive(:get_json).with(any_args).and_return(organization_list_response)
      allow(cmd).to receive(:load_selection!).and_return(proj1_json)
      allow(cmd).to receive(:select).with(stage_name)
    end
    it do
      cmd.options = {"t" => "development", "s" => "standard"}
      cmd.create(stage_name)
    end
  end

end
