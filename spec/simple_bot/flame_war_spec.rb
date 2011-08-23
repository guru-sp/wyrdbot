# encoding: utf-8
require "spec_helper"

describe SimpleIrcBot::FlameWar do

  it "should enable flame war" do
    subject.on!
    subject.should be_on
  end

  it "should disable flame war" do
    subject.off!
    subject.should_not be_on
  end

  context "when flame war is on" do
    before {subject.on!}
    it "should flame on the first found key" do
      subject.random_by_key("ruby").should == "Ruby fede"
    end

    it "should flame on the first found key" do
      subject.flame_on("I love ruby!").should == "Ruby fede"
    end

    it "should not flame if no key was found" do
      subject.flame_on("I love motorcycles").should be_nil
    end
  end
end
