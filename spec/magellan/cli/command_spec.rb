# -*- coding: utf-8 -*-
require 'spec_helper'

describe Magellan::Cli::Command do
  let(:command){ Magellan::Cli::Command.new }
  let(:string){ "string" }

  describe :login do
    describe :intaractive do
      before do
        $stdout = StringIO.new
        allow(command).to receive(:select_single_resources)
        allow(command).to receive(:login!).and_return("OK")
        allow(command).to receive(:login_by_token!).and_return("OK")
      end
      it "nothing options" do
        allow($stdin).to receive(:gets).and_return(string).once
        allow($stdin).to receive(:noecho).and_return(string).once
        expect(command.login).to eq "OK"
        expect($stdout.string).to eq "email: password: \n"
      end

      it "nothing options" do
        allow($stdin).to receive(:gets  ).and_return(string).once # email
        allow($stdin).to receive(:noecho).and_return("\n").twice  # password
        expect(command.login).to eq "OK" 
        expect($stdout.string).to eq "email: password: \nauthentication_token: \n"
      end

      it "only email" do
        allow($stdin).to receive(:noecho).and_return(string).twice
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new email: string
        expect(command.login).to eq "OK"
        expect($stdout.string).to eq "password: \n"
      end

      it "only password" do
        allow($stdin).to receive(:gets).and_return(string).once
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new password: string
        expect(command.login).to eq "OK"
        expect($stdout.string).to eq "email: "
      end

      it "only authentication_token" do
        allow($stdin).to receive(:gets).and_return(string).once
        command.options = Thor::CoreExt::HashWithIndifferentAccess.new authentication_token: string
        expect(command.login).to eq "OK"
        expect($stdout.string).to eq "email: "
      end
    end
  end
end
