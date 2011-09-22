# encoding: utf-8
require "nokogiri"

module SimpleBot
  class Google
    G_SITE = 'http://www.google.com.br'
    G_PATH = '/search'
    G_VARS = 'q'
    FILE_PATH = File.expand_path("../../../google_api.key", __FILE__)

    attr_reader :api_key

    def self.search(params)
      url = G_SITE + G_PATH + '?' + G_VARS + '=' + params
      url = URI.escape(url)
      doc = Nokogiri::HTML(open(url))
      str = doc.css('h3.r').to_s
      urls = str.scan(/<a href="([^"]+)"/)
      urls.flatten!
      urls[0..1].join(' ')
    end

    def self.translate(sl, dl, query)
      host = "https://www.googleapis.com/language/translate/v2?key=#{self.key}"
      qry  = "&source=#{sl}&target=#{dl}&q=#{query}"
      url = host + qry

      response = JSON.parse(google_request(url))

      response["data"]["translations"].first["translatedText"]
    rescue
    end

    def self.search_image(query)
      default_image = "http://farm1.static.flickr.com/62/174356973_563e8ee775_b.jpg"
      service_url = "https://ajax.googleapis.com/ajax/services/search/images"
      query_params = "?v=1.0&key=#{self.key}&q=#{query}"
      url = service_url + query_params

      response = JSON.parse(google_request(url))
      response["responseData"]["results"].first["unescapedUrl"]
      rescue Exception => e
        default_image
    end

   private
    def self.key
      @api_key ||= File.read(SimpleBot.root.join("config/google_api.key")).chomp
    rescue
      raise "Google API code not found! Please add a file called google_api.key with Guru-SP api key to the project root"
    end

    def self.google_request(url)
      open(URI.encode(url)).read
    end
  end
end
