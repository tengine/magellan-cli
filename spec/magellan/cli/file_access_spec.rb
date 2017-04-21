# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::FileAccess do
  describe :ensure_config_dir do
    before do
      @stdout = StringIO.new
      @stdout_orig, $stdout = $stdout, @stdout
      expect(File).to receive(:directory?).with(File.expand_path("~/.config/magellan")).and_return(false)
      expect(FileUtils).to receive(:mkdir_p).with(File.expand_path("~/.config/magellan"))
      @magellan_cli_config_file_orig, ENV["MAGELLAN_CLI_CONFIG_FILE"] = ENV["MAGELLAN_CLI_CONFIG_FILE"], nil
    end
    after do
      $stdout = @stdout_orig
      ENV["MAGELLAN_CLI_CONFIG_FILE"] = @magellan_cli_config_file_orig
    end
    it "print notification message" do
      Magellan::Cli::FileAccess.ensure_config_dir
      [
        %r{\.config/magellan/magellan-cli },
        %r{configuration file}i,
        %r{environment variable}i,
        %r{MAGELLAN_CLI_CONFIG_FILE},
        %r{migration}i,
      ].each do |re|
        expect(@stdout.string).to match(re)
      end
    end
  end
end
