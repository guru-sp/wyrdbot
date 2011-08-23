# encoding: utf-8
class SimpleIrcBot
  module Utils
    def dolar_to_real
      url = 'http://economia.uol.com.br/cotacoes/cambio/dolar-comercial-estados-unidos-principal.jhtm'
      doc = Nokogiri::HTML(open(URI.escape(url)))
      doc.xpath("//div[@class='cambio']/ul/li[1]/p/span[2]").text
    end

    def agendatech
      events = JSON.parse(open("http://www.agendatech.com.br/rss/feed.json").read)
      events.select! do |event|
        event["evento"]["estado"] == "SP" && event["evento"]["nome"].downcase.match(/guru/)
      end
      "O próximo evento está cadastrado para #{events.first["evento"]["data"]}"
    rescue
      "Nenhum evento do Guru-SP cadastrado no Agendatech"
    end
  end
end
