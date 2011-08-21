# encoding: utf-8
require "nokogiri"

class Google
  G_SITE = 'http://www.google.com.br'
  G_PATH = '/search'
  G_VARS = 'q'

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

    text = JSON.parse(open(URI.encode(url)).read)

    text["data"]["translations"].first["translatedText"]
  rescue

  end

 private
  def self.key
    file_path = "#{File.expand_path(File.dirname(__FILE__))}/../../google_api.key"
    @api_key ||= File.open(file_path).read.chomp
  rescue
    raise "Google API code not found! Please add a file called google_api.key with Guru-SP api key to the project root"
  end
end
