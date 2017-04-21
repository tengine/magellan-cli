# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Resources::Worker do

  let(:cmd){ Magellan::Cli::Resources::Worker.new }

  let(:http_conn){ double(:http_conn, :check_login_auth! => nil) }
  before{ allow(cmd).to receive(:http_conn).and_return(http_conn) }

  describe :update do
    describe :success do
      before do
        allow(cmd).to receive(:load_selections).and_return(
                        {Magellan::Cli::Resources::Worker.parameter_name => {"id" => 3, "name" => "worker1"}})
      end

      it "update name" do
        attrs = {"name" => "worker2"}
        res = {"id" => 3, "name" => "worker2"}
        expect(cmd).to receive(:put_json).with("/admin/functions~worker/3/edit.js", { "functions_worker" => attrs })
        allow(cmd).to receive(:default_query).and_return({})
        allow(cmd).to receive(:get_json).with("/admin/functions~worker.json", an_instance_of(Hash)).and_return([res])
        allow(cmd).to receive(:update_selections!).with("functions_worker" => res)
        allow(cmd).to receive(:update_selections!)
        cmd.update(attrs.to_json)
      end

      it "update image_name" do
        attrs = {"image_name" => "groovenauts/worker:0.0.1"}
        res = {"id" => 3, "image_name" => "groovenauts/worker:0.0.2"}
        expect(cmd).to receive(:put_json).with("/admin/functions~worker/3/edit.js", { "functions_worker" => attrs })
        allow(cmd).to receive(:default_query).and_return({})
        expect(cmd).to_not receive(:update_selections!).with("functions_worker" => res)
        expect(cmd).to_not receive(:update_selections!)
        cmd.update(attrs.to_json)
      end
    end
  end

end
