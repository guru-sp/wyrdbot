# encoding: utf-8
module SimpleIrcBot
  module Greetings
    def greet_phrases
      @greets ||= YAML.load_file(File.expand_path(File.dirname(__FILE__))+"/../../talk_files/greetings.yml")
    end

    def day_part
      cur_hour = Time.now.hour
      return :morning if cur_hour >= 5 and cur_hour < 12
      return :afternoon if cur_hour >= 12 and cur_hour < 18
      return :night if cur_hour >= 18 or cur_hour < 5
    end

    def greet(greeting, nick)
      case greeting
      when /[Bb]om [Dd]ia/   then say_greet_for(:good_morning, nick)
      when /[Bb]oa [Tt]arde/ then say_greet_for(:good_afternoon, nick)
      when /[Bb]oa [Nn]oite/ then say_greet_for(:good_evening, nick)
      end
    end

    def greet?(greeting)
      greeting.match(/[Bb]om [Dd]ia/) ||
      greeting.match(/[Bb]oa [Tt]arde/) ||
      greeting.match(/[Bb]oa [Nn]oite/)
    end

    module_function
    def say_greet_for(asking_message, nick)
      phrase = greet_phrases["greet"][asking_message.to_s][day_part.to_s]
      sprintf(phrase, {:nick => nick, :hours => Time.now.strftime("%H:%M")})
    end
  end
end
