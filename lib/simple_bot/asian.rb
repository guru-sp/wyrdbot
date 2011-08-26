module SimpleBot
  class Asian
    URL = "http://reallycuteasians.com/page/"
    
    def self.fetch
      page = rand(319)
      doc = Nokogiri::HTML(open(URL + "#{page}"))
      result = doc.xpath("//div[@class='entry']/p/a/img").to_a.sample
      result['src']
    end
  end
end
