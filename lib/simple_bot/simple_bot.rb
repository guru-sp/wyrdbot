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

        if content.match(/^!(.*)\s+(.*)\n?$/)
          target, query = $~[1], $~[2]

          case target
          when 'google' then say_to_chan(google_search(query))
          when 'doc' then say_to_chan("Documentação: #{query}")
          when 'dolar' then say_to_chan(cotacao_dolar)
          when /^t/
            if target =~ /^t-(..)-(..)/
              say_to_chan(translate($~[1], $~[2], query))
            else
              say_to_chan("Ow, usa o formato: t-ligua1-lingua2. #fikdik")
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
