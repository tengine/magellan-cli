# -*- coding: utf-8 -*-
require 'spec_helper'
require 'magellan/cli/script'

describe Magellan::Cli do
  describe "cli" do
    before do
      Magellan::Cli::Script.io = StringIO.new
    end

    it "pass args to Magellan::Cli::Command.start" do
      expect(Magellan::Cli::Command).to receive(:start).with(%w[foo bar])
      cli %w[foo bar]
    end

    it "parse args" do
      expect(Magellan::Cli::Command).to receive(:start).with(%w[foo bar])
      cli "foo bar"
    end

    it "parse args with space in quotation" do
      expect(Magellan::Cli::Command).to receive(:start).with(["foo bar"])
      cli '"foo bar"'
    end

    it "parse args with space escaped" do
      expect(Magellan::Cli::Command).to receive(:start).with(["foo bar"])
      cli 'foo\ bar'
    end
  end

end
