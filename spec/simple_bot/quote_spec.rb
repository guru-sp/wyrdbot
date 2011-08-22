# encoding: utf-8
require "spec_helper"

describe "SimpleIrcBot::Quote" do
  subject { SimpleIrcBot::Quote.new("I'm testing if this thing works...") }

  it "should add a new quote to the quotes file" do
    subject.add!
    quotes_file = subject.class.file
    quotes_file[:quotes][quotes_file[:quotes].size - 1].should == subject.quote
  end

  it "should return a random quote" do
    not_so_random_number = 0
    subject.class.should_receive(:rand).and_return(not_so_random_number)
    subject.class.random.should subject.class.file[not_so_random_number]
  end

  it "should retrieve a quote from a given user" do
    quotes = {:quotes => ["<PotHix> is here", "<agaelebe> I'm a bot", "<qmx> meh."]}
    YAML.should_receive(:load_file).twice.and_return(quotes)
    subject.class.random_by_user("PotHix").should eql("<PotHix> is here")
    subject.class.random_by_user("qmx").should eql("<qmx> meh.")
  end
end
