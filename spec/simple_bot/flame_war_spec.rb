# encoding: utf-8
require "spec_helper"

describe SimpleBot::FlameWar do

  it "should enable flame war" do
    subject.on!
    expect(subject).to be_on
  end

  it "should disable flame war" do
    subject.off!
    expect(subject).not_to be_on
  end

  context "when flame war is on" do
    before { subject.on! }

    it "should flame on the first found key" do
      expect(subject.random_by_key("ruby")).to eq("Ruby fede")
    end

    it "should flame on the first found key" do
      expect(subject.flame_on("I love ruby!")).to eq("Ruby fede")
    end

    it "should not flame if no key was found" do
      expect(subject.flame_on("I love motorcycles")).to be_nil
    end
  end

  it "should add a flame" do
    sentence = "programa virus ai..."
    subject.add("php", sentence)
    expect(subject.all_sentences["php"]).to include(sentence)
  end
end
