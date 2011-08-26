require 'spec_helper'

describe SimpleBot::Asian do
  describe ".fetch" do
    it "returns a random image" do
      SimpleBot::Asian.stub_chain(:open, :read => Support::Fixtures.load_file("asians.html"))
      SimpleBot::Asian.fetch.should match(/\.jpe?g/)
    end
  end
end
