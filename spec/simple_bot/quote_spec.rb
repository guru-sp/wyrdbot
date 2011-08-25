# encoding: utf-8
require "spec_helper"

describe "SimpleIrcBot::Quote" do
  subject { SimpleIrcBot::Quote.new("I'm testing if this thing works...") }

  it "should add a new phrase to the phrases file" do
    subject.add!
    phrases_file = subject.class.file
    phrases_file[:quotes][phrases_file[:quotes].size - 1].should == subject.phrase
  end

  it "should return a random phrase" do
    not_so_random_number = 0
    subject.class.should_receive(:rand).and_return(not_so_random_number)
    subject.class.random.should subject.class.file[not_so_random_number]
  end

  it "should retrieve a phrase from a given user" do
    phrases = {:phrases => ["<PotHix> is here", "<agaelebe> I'm a bot", "<qmx> meh."]}
    YAML.should_receive(:load_file).twice.and_return(phrases)
    subject.class.random_by_user("PotHix").should eql("<PotHix> is here")
    subject.class.random_by_user("qmx").should eql("<qmx> meh.")
  end
end

