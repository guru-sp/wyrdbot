# encoding: utf-8
require 'spec_helper'

describe SimpleBot::Redhead do
  it "returns random image" do
    SimpleBot::Redhead.stub_chain(:open, :read => Support::Fixtures.load_file('redheads.xml'))
    SimpleBot::Redhead.fetch.should match(/\.(jpe?g|png|gif)/)
  end
end
