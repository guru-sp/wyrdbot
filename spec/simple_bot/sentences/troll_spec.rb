# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Troll" do
  subject { SimpleBot::Troll.new("Please, be smart.") }

  it "should add a new troll quote to troll quotes file" do
    subject.add!
    sentences_file = subject.class.file
    expect(sentences_file["trolls"][sentences_file["trolls"].size - 1]).to eq(subject.sentence)
  end

  it "should add a new named trolling quote to the trolling quotes file" do
    nick = "morellon"
    expect(subject.class.random_to(nick)).to match(/^#{nick},.*/)
  end
end
