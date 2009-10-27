# encoding: utf-8
#
# Original code by Kevin Glowacz 
# found in http://github.com/kjg/simpleircbot
# at 2009-10-26 by bbcoimbra
#

require 'socket'
require 'irc_bot_utils'

class SimpleIrcBot

    include GoogleSearch
    include Utils

  def initialize(server, port, channel, nick = 'wyrd')
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK #{nick}"
    say "USER #{nick} 0 * #{nick.capitalize}"
    say "JOIN ##{@channel}"
    #say_to_chan "#{1.chr}ACTION is here to help#{1.chr}"
  end

  def say(msg)
    puts msg
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

      $stdout.write(msg)
      if msg.match(/:([^!]+)!.*PRIVMSG ##{@channel} :(.*)$/)
        nick = $~[1]
        content = $~[2]

        #put matchers here
        if content.match(/^!([^:]+):(.*)$/)
            target = $~[1]
            query = $~[2]
            query.squeeze!(' ')

            case target
            when 'google' then say_to_chan(google_search(query))
            when 'doc' then say_to_chan("Documentação: #{query}")
            else say_to_chan("Comando não reconhecido!")
            end
        end
        if content.match(/[Bb]om [Dd]ia/)
          say_to_chan("Bom dia, #{nick}!")
        end
        if content.match(/[Bb]oa [Tt]arde/)
          say_to_chan("Boa tarde, #{nick}!")
        end
      end
    end
  end

  def quit
    say "PART ##{@channel} :Saindo!"
    say 'QUIT'
  end
end

