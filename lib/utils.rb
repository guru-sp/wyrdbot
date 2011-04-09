# encoding: utf-8
require 'nokogiri'
require 'open-uri'

module Utils
  def cotacao_dolar
    url = 'http://economia.uol.com.br/cotacoes/cambio/dolar-comercial-estados-unidos-principal.jhtm'
    doc = Nokogiri::HTML(open(URI.escape(url)))
    doc.xpath("//div[@class='cambio']/ul/li[1]/p/span[2]").text
  end

  def translate(sl, dl, str)
    host = "http://translate.google.com"
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
