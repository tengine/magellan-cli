# -*- coding: utf-8 -*-
require 'spec_helper'
require 'thor/core_ext/hash_with_indifferent_access'

describe Magellan::Cli::Messaging::Mqtt do

  let(:cmd){ Magellan::Cli::Messaging::Mqtt.new }

  let(:core){ double(:core) }
  before{ allow(cmd).to receive(:core).and_return(core) }

  let(:success_res){ double(:res, code: 200, body: "SUCCESS!\n") }
  let(:failure_res){ double(:res, code: 401, body: "NOT FOUND!\n") }

  describe :pub do
    it do
      expect(core).to receive(:publish).with("foo.bar", "payload").and_return(nil)
      cmd.pub("foo.bar", "payload")
    end

    it "show error" do
      msg = "Something wrong!"
      expect(core).to receive(:publish).with("foo.bar", "payload").and_raise(msg)
      expect(cmd).to receive(:exit).with(1)
      expect($stderr).to receive(:puts).with("\e[31m[RuntimeError] #{msg}\e[0m")
      cmd.pub("foo.bar", "payload")
    end
  end

  describe :get do
    it "without argument" do
      expect(core).to receive(:get_message).and_return(["topic", "payload"])
      expect($stderr).to receive(:puts).with("topic")
      expect($stdout).to receive(:puts).with("payload")
      cmd.get
    end

    [
     ["with nil"         , nil    ],
     ["with blank string", ""     ],
     ["with topic"       , "topic"],
    ].each do |subject, arg|
      it subject do
        expect(core).to receive(:get_message).with(arg).and_return(["topic", "payload"])
        expect($stderr).to receive(:puts).with("topic")
        expect($stdout).to receive(:puts).with("payload")
        cmd.get(arg)
      end
    end

    it "show error" do
      msg = "Something wrong!"
      expect(core).to receive(:get_message).with("topic").and_raise(msg)
      expect(cmd).to receive(:exit).with(1)
      expect($stderr).to receive(:puts).with("\e[31m[RuntimeError] #{msg}\e[0m")
      cmd.get("topic")
    end
  end
end
