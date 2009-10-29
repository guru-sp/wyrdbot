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

module Greetings
    def day_part
	cur_hour = Time::now.hour
	return :morning if cur_hour >= 5 and cur_hour < 12
	return :afternoon if cur_hour >= 12 and cur_hour < 18
	return :night if cur_hour >= 18 or cur_hour < 5
    end

    def greet(greeting, nick)
	case greeting
	when /[Bb]om [Dd]ia/
	    case day_part
	    when :morning
		"Bom dia, #{nick}!"
	    when :afternoon
		"Boa tarde, #{nick}. Ainda não almoçou? São #{Time::now.strftime("%H:%M")}"
	    when :night
		"Boa noite, #{nick}! Acabou de acordar? O dia já acabou."
	    end
	when /[Bb]oa [Tt]arde/
	    case day_part
	    when :morning
		"Bom dia, #{nick}! Você está adiantado."
	    when :afternoon
		"Boa tarde, #{nick}!"
	    when :night
		"Boa noite, #{nick}! Já escureceu são #{Time::now.strftime("%H:%M")}."
	    end
	when /[Bb]oa [Nn]oite/
	    case day_part
	    when :morning
		"Bom dia, #{nick}! Quanta pressa o dia acabou de começar."
	    when :afternoon
		"Boa tarde, #{nick}. Ainda não escureceu são #{Time::now.strftime("%H:%M")}."
	    when :night
		"Boa noite, #{nick}!"
	    end
	end
    end
end
