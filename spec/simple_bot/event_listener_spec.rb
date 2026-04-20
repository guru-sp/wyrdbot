require 'spec_helper'

describe SimpleBot::EventListener do
  before(:each) do
    allow(described_class).to receive(:events).and_return({})
  end

  let(:quote_mock) { double }

  describe ".on" do
    it "registers an event to a callable object" do
      described_class.on('quote', quote_mock)

      expect(described_class.events[:quote]).to be(quote_mock)
    end

    it "registers more than one event to a callable object" do
      described_class.on('quote', 'add_quote', quote_mock)

      expect(described_class.events[:quote]).to be(quote_mock)
      expect(described_class.events[:add_quote]).to be(quote_mock)
    end
  end

  describe ".dispatch" do
    let(:quote_mock) { double }
    let(:bot_mock) { double }

    before(:each) do
      described_class.on('quote', quote_mock)
    end

    it "calls the appropriate handler on event" do
      expect(quote_mock).to receive(:quote).with(bot_mock, '<FulanoDeTal> Hello guru-sp')

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
        expect(described_class).not_to be_registered('quote')
      end
    end

    context "event is registered" do
      before(:each) do
        described_class.on('quote', double)
      end

      it "returns true" do
        expect(described_class).to be_registered('quote')
      end
    end
  end
end
