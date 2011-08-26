# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Motorcycle" do
  subject { SimpleBot::Motorcycle.new("http://myrockerfxcw.com/wp-content/uploads/2010/05/IMAG0083.jpg") }

  it "should add a new motorcycle quote to the motorcycles file" do
    subject.add!
    phrases_file = subject.class.file
    phrases_file["motorcycles"][phrases_file["motorcycles"].size - 1].should == subject.phrase
  end
end
