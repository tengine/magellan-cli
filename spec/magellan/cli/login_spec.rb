# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Http do

  describe :login! do
    let(:email){ "magellan@groovenauts.jp" }
    let(:password){ "password" }
    let(:auth_token){ "047bcCC1dnyVE+7DWE6YKIJF97L/qHk1mPrf2oaqWtE=" }
    let(:cmd) do
      cmd = double(:cmd)
      allow(cmd).to receive(:verbose?).and_return(false)
      cmd
    end

    before do
      allow(File).to receive(:readable?).and_return(true)
      allow(YAML).to receive(:load_file).with(ENV["MAGELLAN_CLI_CONFIG_FILE"]).and_return({"login" => {"email" => email, "password" => password} })
    end

    context :production do
      before{ allow(Magellan::Cli::Http).to receive(:base_url).and_return("https://example.com") }
      let(:cli){ Magellan::Cli::Http.new(cmd) }
      before do
        res = double(:res)
        allow(cli.httpclient).to receive(:get).with("https://example.com/users/sign_in.html").and_return(res)
        allow(res).to receive(:status).and_return(200)
        allow(res).to receive(:body).and_return(File.read(File.expand_path("../login_page.html", __FILE__)))
        allow(res).to receive(:body_encoding).and_return(Encoding.find("UTF-8"))
      end

      let(:params) do
        {
          "user" => {"email" => email, "password" => password},
          "authenticity_token" => auth_token,
        }
      end

      it :login_success do
        res = double(:res)
        allow(cli.httpclient).to receive(:post).with("https://example.com/api/sign_in.json", params.to_json, Magellan::Cli::JSON_HEADER).and_return(res)
        allow(res).to receive(:status).and_return(200)
        allow(res).to receive(:body).and_return({"success" => true}.to_json)
        allow(res).to receive(:body_encoding).and_return(Encoding.find("UTF-8"))
        expect(cli.api_login!(email, password)).to eq true
      end

      it :login_failure do
        res = double(:res)
        allow(cli.httpclient).to receive(:post).with("https://example.com/api/sign_in.json", params.to_json, Magellan::Cli::JSON_HEADER).and_return(res)
        allow(res).to receive(:status).and_return(401) # Unauthorized
        allow(res).to receive(:body).and_return({"success" => false, "message" => "Error with your login or password"}.to_json)
        allow(res).to receive(:body_encoding).and_return(Encoding.find("UTF-8"))
        expect(cli.api_login!(email, password)).to eq false
      end

      it :login_under_maintenance do
        res = double(:res)
        allow(cli.httpclient).to receive(:get).with("https://example.com/users/sign_in.html").and_return(res)
        allow(res).to receive(:status).and_return(503)
        allow(res).to receive(:body).and_return({"success" => false, "message" => "Under Maintenance"}.to_json)
        allow(res).to receive(:body_encoding).and_return(Encoding.find("UTF-8"))
        expect{cli.api_login!(email, password)}.to raise_error(Magellan::Cli::Error, "Under Maintenance")
      end
    end

    context :development do
      before{ allow(Magellan::Cli::Http).to receive(:base_url).and_return("http://localhost:3001") }
      let(:cli){ Magellan::Cli::Http.new(cmd) }
      before do
        res = double(:res)
        allow(cli.httpclient).to receive(:get).with("http://localhost:3001/users/sign_in.html").and_return(res)
        allow(res).to receive(:status).and_return(200)
        allow(res).to receive(:body).and_return(File.read(File.expand_path("../login_page.html", __FILE__)))
        allow(res).to receive(:body_encoding).and_return(Encoding.find("UTF-8"))
      end

      let(:params) do
        {
          "user" => {"email" => email, "password" => password},
          "authenticity_token" => auth_token,
        }
      end

      it :login_success do
        res = double(:res)
        allow(cli.httpclient).to receive(:post).with("http://localhost:3001/api/sign_in.json", params.to_json, Magellan::Cli::JSON_HEADER).and_return(res)
        allow(res).to receive(:status).and_return(200)
        allow(res).to receive(:body).and_return({"success" => true}.to_json)
        allow(res).to receive(:body_encoding).and_return(Encoding.find("UTF-8"))
        expect(cli.api_login!(email, password)).to eq true
      end
    end
  end

  context :without_login do
    before(:all){ Magellan::Cli::FileAccess.remove_selection_file }

    Magellan::Cli::Resources::MAPPING.keys.each do |classname|
      context classname do
        klass = ::Magellan::Cli::Resources.const_get(classname)
        let(:cmd){ klass.new }

        klass.commands.each do |cmd_name, _|
          next if cmd_name == "help"
          m = klass.instance_method(cmd_name)
          if m.arity == 0
            it "raises Magellan::Cli::Error when #{cmd_name}" do
              expect{ cmd.send(cmd_name) }.to raise_error(Magellan::Cli::Error, /not logined/i)
            end
          end
        end
      end
    end
  end

end
