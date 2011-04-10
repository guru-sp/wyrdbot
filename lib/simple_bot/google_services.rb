# encoding: utf-8
require 'open-uri'

module GoogleServices
  G_SITE = 'http://www.google.com.br'
  G_PATH = '/search'
  G_VARS = 'q'

  def google_search(params)
    url = G_SITE + G_PATH + '?' + G_VARS + '=' + params
    url = URI.escape(url)
    doc = Nokogiri::HTML(open(url))
    str = doc.css('h3.r').to_s
    urls = str.scan(/<a href="([^"]+)"/)
    urls.flatten!
    urls[0..1].join(' ')
  end

  def translate(sl, dl, str)
    raise "Not Implemented yet"

    host = "https://www.googleapis.com/language/translate/v2?key=#{GOOGLEAPI_KEY}&source=en&target=de&callback=translateText&q="
    path = "/translate_a/t?"
    qry = ["client=t",
      "text=#{str}",
    "sl=#{sl}",
    "tl=#{dl}",
    "oc=0",
      "pc=0"] * '&'
    url = host + path + qry
    doc = Nokogiri::HTML(open(URI.encode(url)))
    ret = doc.xpath("//p").text
    ret
  end
end
