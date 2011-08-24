# encoding: utf-8
require "spec_helper"

describe "SimpleIrcBot::Utils" do
  before :all do
    class Dummy; include SimpleIrcBot::Utils; end
  end

  subject { Dummy.new }

  it "should get the guru-sp events from agendatech" do
    event_info = [{"evento"=>{"estado"=>"SP","nome"=>"Guru-SP","data"=>"2011-11-17T00:00:00-02:00"}}]
    subject.stub_chain(:open, :read)
    JSON.should_receive(:parse).and_return(event_info)
    subject.agendatech.should match("17/11/2011 às 00:00")
  end

  it "should get the message for 'no events'" do
    event_info = [{"evento"=>{"estado"=>"RS","nome"=>"RS on Rails","data"=>"2011-11-17T00:00:00-02:00"}}]
    subject.stub_chain(:open, :read)
    JSON.should_receive(:parse).and_return(event_info)
    subject.agendatech.should match("Nenhum evento do Guru-SP cadastrado no Agendatech")
  end
end
