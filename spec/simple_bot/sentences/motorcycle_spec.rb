# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Motorcycle" do
  subject { SimpleBot::Motorcycle.new("http://myrockerfxcw.com/wp-content/uploads/2010/05/IMAG0083.jpg") }

  it "should add a new motorcycle to the motorcycles file" do
    subject.add!
    sentences_file = subject.class.file
    expect(sentences_file["motorcycles"][sentences_file["motorcycles"].size - 1]).to eq(subject.sentence)
  end
end
