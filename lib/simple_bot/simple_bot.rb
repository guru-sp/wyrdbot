# encoding: utf-8
#
# Original code by Kevin Glowacz
# found in http://github.com/kjg/simpleircbot

require 'socket'

class SimpleIrcBot
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
    $stdout.write(msg + "\n")
    @socket.puts msg
  end

  def say_to_chan(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end

  def run
    until @socket.eof? do
      msg = @socket.gets

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        $stderr.write(msg)
        next
      end

      if msg.match(/:([^!]+)!.*PRIVMSG ##{@channel} :(.*)$/)
        nick, content = $~[1], $~[2]

        if content.match(/^!([^\s]*)\s+(.*)(\r?)(\n?)$/)
          target, query = $~[1], $~[2]

          case target
            when 'google' then say_to_chan(google_search(query))
            when 'doc' then say_to_chan("Documentação: #{query}")
            when 'dolar' then say_to_chan(dolar_to_real)
            when /^t/ then say_to_chan(try_to_translate(target, query))
            else
              say_to_chan("Se você pedir direito, talvez eu te ajude!")
          end
          next
        elsif content.match(/^wyrd[,:]([^\s]*)\s+(.*)\n?$/)
          target, query = $~[1], $~[2]
          execute_query(query.chop, nick)
        end

        greeting = greet(content, nick)
        say_to_chan(greeting) if greeting
      end
    end
  end

  def execute_query(query, nick)
    query.match(/^(.*)/)
    query = $~[1]
    puts query.bytes.to_a.inspect
    case query
      when 'teste'
        say_to_chan "Tudo ok por aqui, #{nick}"
      when 'horas'
        say_to_chan "Agora são #{Time.now.strftime('%H:%M')}, #{nick}"
      when 'memoria', 'memória'
        say_to_chan "Ainda tenho #{%x(free -m).split(' ')[9]}MB livres, #{nick}"
      else
        puts query
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
end
