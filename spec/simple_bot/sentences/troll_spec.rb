# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Troll" do
  subject { SimpleBot::Troll.new("Please, be smart.") }

  it "should add a new troll quote to troll quotes file" do
    subject.add!
    sentences_file = subject.class.file
    sentences_file["trolls"][sentences_file["trolls"].size - 1].should == subject.sentence
  end

  it "should add a new named trolling quote to the tralling quotes file" do
    nick = "morellon"
    subject.class.random_to(nick).should match(/^#{nick},.*/)
  end
end
