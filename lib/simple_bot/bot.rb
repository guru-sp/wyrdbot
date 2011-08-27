# encoding: utf-8
#
# Original code by Kevin Glowacz
# found in http://github.com/kjg/simpleircbot

module SimpleBot
  class Bot
    REPO = "https://github.com/guru-sp/Guru-sp-IRC-Bot"

    include Utils
    include Greetings
    include EdRobot
    include Logger

    def initialize(config)
      @socket = TCPSocket.open(config["network"]["server"], config["network"]["port"])
      @channel = config["network"]["channel"]
      @nick = config["user"]["nickname"]

      say "NICK #{@nick}"
      say "USER #{@nick} 0 * #{@nick.capitalize}"
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
      logger.debug(full_message.chomp)

      case full_message
      when /\APING :(.*)$/
        say "PONG #{$1}"
        return $stderr.write(full_message)
      when /#{@nick} = ##{@channel} :(.*?)$/
        count = $1.split(" ").size
        return say_to_chan("Agora tem #{count} pessoas no canal")
      end

      if full_message.match(/:([^!]+)!.*PRIVMSG ##{@channel} :(.*)$/)
        nick, content = $1, $2

        if content.match(/^!([^\s?]*)\s*(.*?)?\s*$/)
          target, query = $1, $2

          case target
          when 'add_quote'
            unless query.match(/#{@nick.downcase}/i)
              quote = Quote.new(query)
              quote.add!
              say_to_chan("Boa! Seu quote foi adicionado com sucesso! \\o/")
            else
              say_to_chan("Não sou tão idiota de ficar adicionando quotes que mencionem a mim ;)")
            end
          when 'quote'
            unless query.empty?
              say_to_chan(Quote.random_by_search(query))
            else
              say_to_chan(Quote.random)
            end
          when 'add_flame'
            if query =~ /^(\w+)\s*,\s*(.+)/
              FlameWar.add($1, $2)
              say_to_chan("Aff... seu trollzinho da Bahia... Flame adicionado")
            else
              say_to_chan("Ow usa o formato: !add_flame <key>, <sentence>")
            end
          when 'flame'
            if query == "on"
              FlameWar.on!
              say_to_chan("Flame war is on! \\m/")
            elsif query == "off"
              FlameWar.off!
              say_to_chan("Flame war is off! What a fag!")
            else
              say_to_chan("Uma flame war só pode ser on ou off, fikdik")
            end
          when 'agendatech'
            say_to_chan(agendatech)
          when 'doc'
            say_to_chan("Documentação: #{query}")
          when 'dolar'
            say_to_chan(dollar_to_real(query))
          when 'google'
            say_to_chan(Google.search(query))
          when 'ruiva'
            say_to_chan(Redhead.fetch)
          when 'asian'
            say_to_chan(Asian.fetch)
          when 'git'
            say_to_chan(REPO)
          when 'pr0n'
            say_to_chan(Pr0n.search(query))
          when 'count'
            say "NAMES #guru-sp"
          when 'add_motorcycle'
            motorcycle = Motorcycle.new(query)
            motorcycle.add!
            say_to_chan("Nova moto adicionada com sucesso! \\,,/")
          when 'motorcycle'
            say_to_chan(Motorcycle.random)
          when /^t/
            wrong_message = "Ow usa o formato: t-idioma1-idioma2. #fikdik"
            response = target =~ /^t-(..)-(..)/ ? Google.translate($1, $2, query) : wrong_message
            say_to_chan(response)
          else
            say_to_chan("Ow, isso ae ainda não está implementado...Pull request!!")
          end
          return
        elsif content.match(/^#{@nick}[,:]([^\s]*)\s+(.*)\n?$/)
          target, query = $1, $2
          execute_query(query.chop, nick)
        elsif greet?(content)
          say_to_chan(greet(content, nick))
        else
          say_to_chan(FlameWar.flame_on(content))
        end
      end
    rescue => e
      logger.error("Message control for '#{full_message}' failed with error: #{e.message}")
    end

    def execute_query(query, nick)
      case query
      when 'teste'
        say_to_chan "Tudo ok por aqui, #{nick}"
      when 'memoria', 'memória'
        say_to_chan "Ainda tenho #{%x(free -m).split(' ')[9]}MB livres, #{nick}"
      when 'help'
        say_to_chan "Respondo a memoria e teste, e to assistindo algumas paradas com exclamação, como !quote, !add_quote, !google, !doc, !dolar, !agendatech, !pr0n, !ruiva, !asian, !count, !motorcycle, !add_motorcycle, !add_flame, !git, e traduções com !t-en-pt por exemplo."
      else
        say_to_chan("#{nick}: #{ask_to_ed(query)}")
      end
    end

    def quit
      say "PART ##{@channel} :Saindo!"
      say 'QUIT'
    end
  end
end
