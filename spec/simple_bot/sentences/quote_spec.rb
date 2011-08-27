# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Quote" do
  subject { SimpleBot::Quote.new("Guru-SP rocks!") }

  it "should add a new quote to the quotes file" do
    subject.add!
    sentences_file = subject.class.file
    sentences_file["quotes"][sentences_file["quotes"].size - 1].should == subject.sentence
  end
end
