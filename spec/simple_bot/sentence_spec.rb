# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Sentence" do
  subject { SimpleBot::Sentence.new("I'm testing if this thing works...") }

  it "should add a new sentence to the sentences file" do
    subject.add!
    sentences_file = subject.class.file
    sentences_file["sentences"][sentences_file["sentences"].size - 1].should == subject.sentence
  end

  it "should return a random sentence" do
    not_so_random_number = 0
    subject.class.should_receive(:rand).and_return(not_so_random_number)
    subject.class.random.should subject.class.file[not_so_random_number]
  end

  it "should return the class name downcased as a symbol" do
    subject.class.class_name.should eql(:sentence)
  end
end
