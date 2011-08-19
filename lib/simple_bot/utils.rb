# encoding: utf-8
module Utils
  def dolar_to_real
    url = 'http://economia.uol.com.br/cotacoes/cambio/dolar-comercial-estados-unidos-principal.jhtm'
    doc = Nokogiri::HTML(open(URI.escape(url)))
    doc.xpath("//div[@class='cambio']/ul/li[1]/p/span[2]").text
  end
end
