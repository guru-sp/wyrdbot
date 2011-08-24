# encoding: utf-8
module SimpleIrcBot
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
      date = events.first["evento"]["data"].match(/(?<year>[0-9]{4})-(?<month>[0-9]{2})-(?<day>[0-9]{2})T(?<hour>[0-9]{2}:[0-9]{2})/)
      "O próximo evento do Guru-SP está cadastrado para #{date[:day]}/#{date[:month]}/#{date[:year]} às #{date[:hour]}"
    rescue
      "Nenhum evento do Guru-SP cadastrado no Agendatech"
    end
  end
end
