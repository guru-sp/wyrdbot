# encoding: utf-8
require 'spec_helper'

describe SimpleBot::Redhead do
  describe "#image" do
    it "returns random image" do
      allow(subject).to receive_message_chain(:open, :read).and_return(Support::Fixtures.load_file('redheads.xml'))

      expect(subject.image).to match(/\.(jpe?g|png|gif)/)
    end
  end

  describe "#ruiva" do
    let(:bot_mock) { double }

    it "says to the channel with redhead image" do
      expect(bot_mock).to receive(:say_to_chan).with('ruiva.jpg')
      allow(subject).to receive(:image).and_return('ruiva.jpg')

      subject.ruiva(bot_mock)
    end
  end

  describe "event handler" do
    it "register 'ruiva' with appropriate handler" do
      expect(SimpleBot::EventListener.events[:ruiva]).to be_a(SimpleBot::Redhead)
    end
  end
end
