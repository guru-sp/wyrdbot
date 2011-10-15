require 'spec_helper'

describe SimpleBot::EventListener do
  before(:each) do
    described_class.stub(:events => {})
  end

  let(:quote_mock) { mock }

  describe ".on" do
    it "registers an event to a callable object" do
      described_class.on('quote', quote_mock)

      described_class.events[:quote].should be(quote_mock)
    end

    it "registers more than one event to a callable object" do
      described_class.on('quote', 'add_quote', quote_mock)

      described_class.events[:quote].should be(quote_mock)
      described_class.events[:add_quote].should be(quote_mock)
    end
  end

  describe ".dispatch" do
    let(:quote_mock) { mock }
    let(:bot_mock) { mock }

    before(:each) do
      described_class.on('quote', quote_mock)
    end

    it "calls the appropriate handler on event" do
      quote_mock.should_receive(:quote).with(bot_mock, '<FulanoDeTal> Hello guru-sp')

      described_class.dispatch('quote', '<FulanoDeTal> Hello guru-sp', bot_mock)
    end

    it "fails on unexpected message" do
      expect {
        described_class.dispatch('abobrinha', 'Salada', bot_mock)
      }.to raise_error(NoMethodError)
    end
  end

  describe ".registered?" do
    context "event is not registered" do
      it "returns false" do
        described_class.should_not be_registered('quote')
      end
    end

    context "event is registered" do
      before(:each) do
        described_class.on('quote', mock)
      end

      it "returns true" do
        described_class.should be_registered('quote')
      end
    end
  end
end
