# encoding: utf-8
require "spec_helper"

describe SimpleBot::EdRobot do
  before :all do
    class Dummy; include SimpleBot::EdRobot; end
  end

  subject { Dummy.new }

  it "should ask to EdRobot" do
    service = "http://www.ed.conpet.gov.br/mod_perl/bot_gateway.cgi"
    question = "Qual seu nome?"
    options = {
      :query => {
        :server => "0.0.0.0:8085",
        :charset_post => "utf-8",
        :pure => 1,
        :js => 0,
        :tst => 1,
        :msg => question
      }
    }

    response = double("response")
    expect(response).to receive(:body).and_return("wyrd")

    expect(HTTParty).to receive(:get).with(service, options).and_return(response)
    expect(subject.ask_to_ed(question)).to eql("wyrd")
  end
end
