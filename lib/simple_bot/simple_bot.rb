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
        nick = $~[1]
        content = $~[2]

        if content.match(/^!(.*)\s(.*)$/)
          target, query = $~[1], $~[2]
          query.squeeze!(' ')
          query.strip!

          case target
          when 'google' then say_to_chan(google_search(query))
          when 'doc' then say_to_chan("Documentação: #{query}")
          when 'dolar' then say_to_chan(cotacao_dolar)
          when /^t/
            if target =~ /^t-(..)-(..)/
              say_to_chan("Trad: #{translate($~[1], $~[2], query)}")
            else
              say_to_chan("Não pude traduzir")
            end
          else
            say_to_chan("Se você pedir direito, talvez eu te ajude!")
          end
          next
        end

        greeting = greet(content, nick)
        say_to_chan(greeting) if greeting
      end
    end
  end

  def quit
    say "PART ##{@channel} :Saindo!"
    say 'QUIT'
  end
end
