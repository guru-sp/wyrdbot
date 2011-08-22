# encoding: utf-8
module EdRobot
  def ask_to_ed(question)
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

    response = HTTParty.get("http://www.ed.conpet.gov.br/mod_perl/bot_gateway.cgi", options)
    response.body.chomp
  end
end