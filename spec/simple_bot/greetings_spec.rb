# encoding: utf-8
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

  it "shoud return false if it is not a great" do
    subject.is_a_greet?("ahh falo").should be_false
  end

  it "shoud return true if it is a great" do
    subject.is_a_greet?("Bom dia").should be_true
  end

  context "when greeting" do
    let(:hours){ "10:10" }
    let(:nick){ "Bill Gates" }
    let(:greet_responses){ YAML.load_file(File.expand_path(File.dirname(__FILE__))+"/../speak/greetings.yml") }

    before { Time.stub_chain(:now, :strftime).and_return(hours)}

    context "in the morning" do
      before { subject.should_receive(:day_part).and_return(:morning) }

      it "should greet correctly with morning greet for a morning asking" do
        resp = sprintf(greet_responses["greet"]["good_morning"]["morning"], {:nick => nick})
        response_phrase = subject.greet("Bom dia fio di quenga!", nick)
        response_phrase.should eql(resp)
      end

      it "should greet correctly with morning greet for a afternoon asking" do
        resp = sprintf(greet_responses["greet"]["good_afternoon"]["morning"], {:nick => nick})
        response_phrase = subject.greet("Boa tarde fio di quenga!", nick)
        response_phrase.should eql(resp)
      end

      it "should greet correctly with morning greet for a night asking" do
        resp = sprintf(greet_responses["greet"]["good_evening"]["morning"], {:nick => nick})
        response_phrase = subject.greet("Boa noite fio di quenga!", nick)
        response_phrase.should eql(resp)
      end
    end

    context "in the afternoon" do
      before { subject.should_receive(:day_part).and_return(:afternoon) }

      it "should greet correctly with morning greet for a morning asking" do
        resp = sprintf(greet_responses["greet"]["good_morning"]["afternoon"], {:nick => nick, :hours => hours})
        response_phrase = subject.greet("Bom dia fio di quenga!", nick)
        response_phrase.should eql(resp)
      end

      it "should greet correctly with morning greet for a afternoon asking" do
        resp = sprintf(greet_responses["greet"]["good_afternoon"]["afternoon"], {:nick => nick})
        response_phrase = subject.greet("Boa tarde fio di quenga!", nick)
        response_phrase.should eql(resp)
      end

      it "should greet correctly with morning greet for a night asking" do
        resp = sprintf(greet_responses["greet"]["good_evening"]["afternoon"], {:nick => nick, :hours => hours})
        response_phrase = subject.greet("Boa noite fio di quenga!", nick)
        response_phrase.should eql(resp)
      end
    end

    context "in the night" do
      before { subject.should_receive(:day_part).and_return(:night) }

      it "should greet correctly with morning greet for a morning asking" do
        resp = sprintf(greet_responses["greet"]["good_morning"]["night"], {:nick => nick})
        response_phrase = subject.greet("Bom dia fio di quenga!", nick)
        response_phrase.should eql(resp)
      end

      it "should greet correctly with morning greet for a afternoon night" do
        resp = sprintf(greet_responses["greet"]["good_afternoon"]["night"], {:nick => nick, :hours => hours})
        response_phrase = subject.greet("Boa tarde fio di quenga!", nick)
        response_phrase.should eql(resp)
      end

      it "should greet correctly with morning greet for a night night" do
        resp = sprintf(greet_responses["greet"]["good_evening"]["night"], {:nick => nick})
        response_phrase = subject.greet("Boa noite fio di quenga!", nick)
        response_phrase.should eql(resp)
      end
    end
  end
end
