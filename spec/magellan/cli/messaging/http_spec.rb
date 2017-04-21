# -*- coding: utf-8 -*-
require 'spec_helper'
require 'thor/core_ext/hash_with_indifferent_access'

describe Magellan::Cli::Messaging::Http do

  let(:cmd){ Magellan::Cli::Messaging::Http.new }

  let(:core){ double(:core) }
  before{ allow(cmd).to receive(:core).and_return(core) }

  let(:success_res){ double(:res, code: 200, body: "SUCCESS!\n") }
  let(:failure_res){ double(:res, code: 401, body: "NOT FOUND!\n") }

  [:get, :delete, :post, :put, :patch].each do |http_method|
    describe http_method do
      it "path only" do
        expect(core).to receive(:request).with("/foo", http_method, nil, {}).and_return(success_res)
        cmd.send(http_method, "/foo")
      end
      it "path only(401 error)" do
        expect(core).to receive(:request).with("/foo", http_method, nil, {}).and_return(failure_res)
        cmd.send(http_method, "/foo")
      end
      it "path and query string" do
        expect(core).to receive(:request).with("/foo?bar=baz", http_method, nil, {}).and_return(success_res)
        cmd.send(http_method, "/foo?bar=baz")
      end
      it "path and headers" do
        expect(core).to receive(:request).with("/foo", http_method, nil, {"bar" => "baz"}).and_return(success_res)
        cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new headers: '{"bar":"baz"}'
        cmd.send(http_method, "/foo")
      end

      let(:header_content){ YAML.load_file(File.expand_path("../http_headers.yml", __FILE__)) }
      it "path and headers yaml file" do
        expect(core).to receive(:request).with("/foo", http_method, nil, header_content).and_return(success_res)
        cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new headers: File.expand_path("../http_headers.yml", __FILE__)
        cmd.send(http_method, "/foo")
      end
      it "path and headers json file" do
        expect(core).to receive(:request).with("/foo", http_method, nil, header_content).and_return(success_res)
        cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new "headers" => File.expand_path("../http_headers.json", __FILE__)
        cmd.send(http_method, "/foo")
      end
    end
  end

  [:post, :put, :patch].each do |http_method|
    describe "#{http_method} with body" do
      text = "foo\nbar\n\nbazbazbaz"
      text_filename = File.expand_path("../http_body.txt" , __FILE__)
      json_filename = File.expand_path("../http_body.json", __FILE__)
      [
        ["text"     , text         , text],
        ["text file", text_filename, File.read(text_filename)],
        ["JSON file", json_filename, File.read(json_filename)],
      ].each do |context_nane, arg, expected|
        context context_nane do
          it "path only" do
            expect(core).to receive(:request).with("/foo", http_method, expected, {}).and_return(success_res)
            cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new body: arg
            cmd.send(http_method, "/foo")
          end
          it "path only(401 error)" do
            expect(core).to receive(:request).with("/foo", http_method, expected, {}).and_return(failure_res)
            cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new body: arg
            cmd.send(http_method, "/foo")
          end
          it "path and query string" do
            expect(core).to receive(:request).with("/foo?bar=baz", http_method, expected, {}).and_return(success_res)
            cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new body: arg
            cmd.send(http_method, "/foo?bar=baz")
          end
          it "path and headers" do
            expect(core).to receive(:request).with("/foo", http_method, expected, {"bar" => "baz"}).and_return(success_res)
            cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new body: arg, headers: '{"bar":"baz"}'
            cmd.send(http_method, "/foo")
          end

          let(:header_content){ YAML.load_file(File.expand_path("../http_headers.yml", __FILE__)) }
          it "path and headers yaml file" do
            expect(core).to receive(:request).with("/foo", http_method, expected, header_content).and_return(success_res)
            cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new body: arg, headers: File.expand_path("../http_headers.yml", __FILE__)
            cmd.send(http_method, "/foo")
          end
          it "path and headers json file" do
            expect(core).to receive(:request).with("/foo", http_method, expected, header_content).and_return(success_res)
            cmd.options = Thor::CoreExt::HashWithIndifferentAccess.new "body" => arg, "headers" => File.expand_path("../http_headers.json", __FILE__)
            cmd.send(http_method, "/foo")
          end
        end
      end
    end
  end
end
