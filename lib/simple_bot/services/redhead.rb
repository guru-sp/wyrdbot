# encoding: utf-8
module SimpleBot
  class Redhead
    ENDPOINT = "http://fuckyeahredhair.tumblr.com/api/read?num=50&type=photo"

    def image
      xml = Nokogiri::XML(open(ENDPOINT))
      xml.css("photo-url[@max-width='500']").collect(&:text).sample
    end

    def ruiva(bot, payload="")
      bot.say_to_chan(image)
    end
  end
end

SimpleBot::EventListener.on('ruiva', SimpleBot::Redhead.new)
