# encoding: iso-8859-1

require 'nokogiri'
require 'open-uri'

module GoogleSearch

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

end

module Utils
    def cotacao_dolar
        url = 'http://economia.uol.com.br/cotacoes/cambio/dolar-comercial-estados-unidos-principal.jhtm'
        doc = Nokogiri::HTML(open(URI.escape(url)))
        doc.xpath("//div[@class='cambio']/ul/li[1]/p/span[2]").text
    end
end
