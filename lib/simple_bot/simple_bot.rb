# encoding: utf-8
#
# Original code by Kevin Glowacz
# found in http://github.com/kjg/simpleircbot

class SimpleIrcBot
  LOG_PATH = File.expand_path(File.dirname(__FILE__))+"/../../log/wyrd.log"

  include Utils
  include Greetings

  def initialize(server, port, channel, nick = 'wyrd')
    @nick = nick
    @logger = Logger.new(LOG_PATH)
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
          when 'add_quote'
            unless query.match(/#{@nick}/)
              quote = Quote.new(query)
              quote.add!
              say_to_chan("Boa! Seu quote foi adicionado com sucesso! \\o/")
            else
              say_to_chan("Não sou tão idiota de ficar adicionando quotes que mencionem a mim ;)")
            end
          when 'quote'
            say_to_chan(Quote.random)
          when 'doc'
            say_to_chan("Documentação: #{query}")
          when 'dolar'
            say_to_chan(dolar_to_real)
          when 'google'
            say_to_chan(Google.search(query))
          when /^t/
            wrong_message = "Ow usa o formato: t-idioma1-idioma2. #fikdik"
            response = target =~ /^t-(..)-(..)/ ? Google.translate($~[1], $~[2], query) : wrong_message
            say_to_chan(response)
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
        say_to_chan "Respondo a memoria e teste, e to assistindo algumas paradas com exclamação, como !quote, !add_quote, !google, !doc, !dolar, e traduções com !t-en-pt por exemplo."
      else
        say_to_chan("#{nick}: sei lá")
    end
  end

  def quit
    say "PART ##{@channel} :Saindo!"
    say 'QUIT'
  end
end
