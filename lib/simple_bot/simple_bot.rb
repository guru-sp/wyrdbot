# encoding: utf-8
#
# Original code by Kevin Glowacz
# found in http://github.com/kjg/simpleircbot

class SimpleIrcBot
  QUOTES_PATH = File.expand_path(File.dirname(__FILE__))+"/../../speak/quotes.yml"

  include GoogleServices
  include Utils
  include Greetings

  def initialize(server, port, channel, nick = 'wyrd')
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK #{nick}"
    say "USER #{nick} 0 * #{nick.capitalize}"
    say "JOIN ##{@channel}"
  end

  def say(msg)
    @socket.puts msg
  end

  def say_to_chan(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end

  def run
    until @socket.eof? do
      message_control(@socket, @socket.gets)
    end
  end

  def message_control(socket, full_message)
    if full_message.match(/^PING :(.*)$/)
      say "PONG #{$~[1]}"
      $stderr.write(full_message)
      return
    end

    if full_message.match(/:([^!]+)!.*PRIVMSG ##{@channel} :(.*)$/)
      nick, content = $~[1], $~[2]

      if content.match(/^!([^\s?]*)\s?+(.*)?(\r?|\n?)$/)
        target, query = $~[1], $~[2]

        case target
          when 'add_quote' then add_quote(query)
          when 'quote' then say_to_chan(quote)
          when 'google' then say_to_chan(google_search(query))
          when 'doc' then say_to_chan("Documentação: #{query}")
          when 'dolar' then say_to_chan(dolar_to_real)
          when /^t/ then say_to_chan(try_to_translate(target, query))
          else
            say_to_chan("Ow, isso ae ainda não está implementado...Pull request!!")
        end
        return
      elsif content.match(/^wyrd[,:]([^\s]*)\s+(.*)\n?$/)
        target, query = $~[1], $~[2]
        execute_query(query.chop, nick)
      elsif is_a_greet?(content)
        say_to_chan(greet(content, nick))
      end
    end
  end

  def execute_query(query, nick)
    query.match(/^(.*)/)
    query = $~[1]
    case query
      when 'teste'
        say_to_chan "Tudo ok por aqui, #{nick}"
      when 'memoria', 'memória'
        say_to_chan "Ainda tenho #{%x(free -m).split(' ')[9]}MB livres, #{nick}"
      when 'help'
        say_to_chan "Respondo a memoria e teste, e to assistindo algumas paradas com exclamação, como !google, !doc, !dolar, e traduções com !t-en-pt por exemplo."
      else
        say_to_chan("#{nick}: sei lá")
    end
  end

  def try_to_translate(target, query)
    wrong_format = "Ow, usa o formato: t-idioma1-idioma2. #fikdik"
    begin
      target =~ /^t-(..)-(..)/ ? translate($~[1], $~[2], query) : wrong_format
    rescue
      "Não conheço o idioma que você pediu"
    end
  end

  def quit
    say "PART ##{@channel} :Saindo!"
    say 'QUIT'
  end

  #FIXME: refactor these two methods to a class caching the yaml file
  def add_quote(quote)
    @quotes_file ||= YAML.load_file(QUOTES_PATH)
    @quotes_file[:quotes] << quote
    File.open(QUOTES_PATH, "w"){|f| YAML.dump(@quotes_file, f)}
  end

  def quote
    @quotes_file ||= YAML.load_file(QUOTES_PATH)
    @quotes_file[:quotes][rand(@quotes_file[:quotes].size)]
  end
end
