require 'spec_helper'

describe Magellan::Cli do
  it 'has a version number' do
    expect(Magellan::Cli::VERSION).not_to be nil
  end
end
