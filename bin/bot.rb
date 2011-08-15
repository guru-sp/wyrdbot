$LOAD_PATH.unshift File.join( File.dirname( __FILE__ ), "../lib")

require "daemons"
require "simple_bot"

Daemons.run_proc("wyrd") do
  bot = SimpleIrcBot.new("irc.freenode.net", 6667, "guru-sp")
  trap("INT"){ bot.quit }
  bot.run
end
