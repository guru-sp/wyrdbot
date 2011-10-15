# encoding: utf-8
require 'spec_helper'

describe SimpleBot::Redhead do
  describe "#image" do
    it "returns random image" do
      subject.stub_chain(:open, :read => Support::Fixtures.load_file('redheads.xml'))

      subject.image.should match(/\.(jpe?g|png|gif)/)
    end
  end

  describe "#ruiva" do
    let(:bot_mock) { mock }

    it "says to the channel with redhead image" do
      bot_mock.should_receive(:say_to_chan).with('ruiva.jpg')
      subject.stub(:image => 'ruiva.jpg')

      subject.ruiva(bot_mock)
    end
  end

  describe "event handler" do
    it "register 'ruiva' with appropriate handler" do
      SimpleBot::EventListener.events[:ruiva].should be_a(SimpleBot::Redhead)
    end
  end
end
