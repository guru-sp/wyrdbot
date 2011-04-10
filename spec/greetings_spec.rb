require "spec_helper"

describe "Greetings" do
  before :all do
    class Dummy; include Greetings; end
  end

  subject { Dummy.new }

  context "when verifying the current part of the day" do
    it "should return morning for a 10:00" do
      Time.stub_chain(:now, :hour).and_return(10)
      subject.day_part.should eql(:morning)
    end

    it "should return afternoon for 15:00" do
      Time.stub_chain(:now, :hour).and_return(15)
      subject.day_part.should eql(:afternoon)
    end

    it "should return night for 23:00" do
      Time.stub_chain(:now, :hour).and_return(23)
      subject.day_part.should eql(:night)
    end
  end
end
