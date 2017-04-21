# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Messaging::Http do

  let(:cmd){ Magellan::Cli::Messaging::Http.new }

  describe :login_by_token do
    let(:email)    { "user1@example.com" }
    let(:password) { "password" }
    let(:success_res) { double(:success_res, status: 200) }
    let(:error_res)   { double(:error_res, status: 401) }

    it "success" do
      allow(cmd.http_conn.httpclient).to receive(:get).and_return(success_res)
      cmd.login_by_token!(email, password)
    end

    it "error" do
      allow(cmd.http_conn.httpclient).to receive(:get).and_return(error_res)
      expect{cmd.login_by_token!(email, password)}.to raise_error(SystemExit)
    end
  end
end
