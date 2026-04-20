require 'spec_helper'

describe SimpleBot::Asian do
  describe ".fetch" do
    it "returns a random image" do
      allow(SimpleBot::Asian).to receive_message_chain(:open, :read).and_return(Support::Fixtures.load_file("asians.html"))
      expect(SimpleBot::Asian.fetch).to match(/\.jpe?g/)
    end
  end
end
