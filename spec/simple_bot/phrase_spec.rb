# encoding: utf-8
require "spec_helper"

describe "SimpleIrcBot::Phrase" do
  subject { SimpleIrcBot::Phrase.new("I'm testing if this thing works...") }

  it "should add a new phrase to the phrases file" do
    subject.add!
    phrases_file = subject.class.file
    phrases_file["phrases"][phrases_file["phrases"].size - 1].should == subject.phrase
  end

  it "should return a random phrase" do
    not_so_random_number = 0
    subject.class.should_receive(:rand).and_return(not_so_random_number)
    subject.class.random.should subject.class.file[not_so_random_number]
  end

  it "should return the class name downcased as a symbol" do
    subject.class.class_name.should eql(:phrase)
  end
end
