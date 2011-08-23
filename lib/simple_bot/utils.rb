# encoding: utf-8
class SimpleIrcBot
  module Utils
    def dolar_to_real
      url = 'http://economia.uol.com.br/cotacoes/cambio/dolar-comercial-estados-unidos-principal.jhtm'
      doc = Nokogiri::HTML(open(URI.escape(url)))
      doc.xpath("//div[@class='cambio']/ul/li[1]/p/span[2]").text
    end

    LOG_PATH = File.expand_path(File.dirname(__FILE__))+"/../../log/wyrd.log"

    def logger
      @logger ||= resolve_logger
    end

    def resolve_logger
      return Logger.new(STDOUT) if ARGV.member? "-t"
      Logger.new(LOG_PATH)
    end
  end
end
