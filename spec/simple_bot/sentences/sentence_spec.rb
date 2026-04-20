# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Sentence" do
  subject { SimpleBot::Sentence.new("I'm testing if this thing works...") }

  it "should add a new sentence to the sentences file" do
    subject.add!
    sentences_file = subject.class.file
    expect(sentences_file["sentences"][sentences_file["sentences"].size - 1]).to eq(subject.sentence)
  end

  it "should return a random sentence" do
    not_so_random_number = 0
    expect(subject.class).to receive(:rand).and_return(not_so_random_number)
    expect(subject.class.random).to eq(subject.class.file["sentences"][not_so_random_number])
  end

  it "should return the class name downcased as a symbol" do
    expect(subject.class.class_name).to eql(:sentence)
  end
end
