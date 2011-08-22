# encoding: utf-8
require "spec_helper"

describe EdRobot do
  before :all do
    class Dummy; include EdRobot; end
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

    response = mock("response")
    response.should_receive(:body).and_return("wyrd")

    HTTParty.should_receive(:get).with(service, options).and_return(response)
    subject.ask_to_ed(question).should eql "wyrd"
  end
end
