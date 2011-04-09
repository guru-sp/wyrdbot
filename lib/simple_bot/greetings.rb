# encoding: utf-8
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
