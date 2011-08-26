# encoding: utf-8
module SimpleBot
  class Redhead
    ENDPOINT = "http://fuckyeahredhair.tumblr.com/api/read?num=50&type=photo"

    def self.fetch
      xml = Nokogiri::XML(open(ENDPOINT))
      xml.css("photo-url[@max-width='500']").collect(&:text).sample
    end
  end
end
