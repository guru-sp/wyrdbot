$LOAD_PATH.unshift File.join( File.dirname( __FILE__ ), "../lib")

require 'simple_bot'

bot = SimpleIrcBot.new("irc.freenode.net", 6667, "guru-sp")

trap("INT"){ bot.quit }

bot.run
