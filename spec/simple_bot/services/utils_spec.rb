# encoding: utf-8
require "spec_helper"

describe "SimpleBot::Utils" do
  class Dummy; include SimpleBot::Utils; end

  subject { Dummy.new }

  describe "#agendatech" do
    it "should get the guru-sp events" do
      event_info = [{"evento"=> {
        "estado"=>"SP",
        "nome"=>"Guru-SP",
        "data"=>"2011-11-17T00:00:00-02:00",
        "descricao"=>"horário: 10:00"
      }}]
      allow(subject).to receive_message_chain(:open, :read).and_return(event_info.to_json)
      expect(subject.agendatech).to include("17/11/2011 às 10:00")
    end

    it "should get the message for 'no events'" do
      event_info = [{"evento"=>{
        "estado"=>"RS",
        "nome"=>"RS on Rails",
        "data"=>"2011-11-17T00:00:00-02:00",
        "descricao"=>""
      }}]
      allow(subject).to receive_message_chain(:open, :read).and_return(event_info.to_json)
      expect(subject.agendatech).to match("Nenhum evento do Guru-SP cadastrado no Agendatech")
    end
  end

  describe "#dollar_to_real" do
    before do
      allow(subject).to receive_message_chain(:open, :read).and_return(%["USDBRL=X",1.6096,"8/26/2011","2:31am"])
    end

    it "should return dollar amount" do
      expect(subject.dollar_to_real("")).to eq("R$ 1.61")
    end

    it "should return dollar total amount" do
      expect(subject.dollar_to_real("10")).to eq("R$ 16.10")
    end

    it "should calculate based on R$1 when cannot parse amount" do
      expect(subject.dollar_to_real("asdf")).to eq("R$ 1.61")
    end

    it "should replace comma" do
      expect(subject.dollar_to_real("10,00")).to eq("R$ 16.10")
    end

    it "should wrap exception" do
      allow(subject).to receive_message_chain(:open, :read).and_raise(Exception)
      expect(subject.dollar_to_real("10,00")).to eq("Não consegui saber a cotação")
    end
  end
end
