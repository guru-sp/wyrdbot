$LOAD_PATH.unshift File.join( File.dirname( __FILE__ ), "../lib")

require "daemons"
require "simple_bot"
require "yaml"


CONFIG = File.join(File.expand_path(File.dirname(__FILE__)), "../config/wyrd.yml")

Daemons.run_proc("wyrd") do
  bot = SimpleIrcBot.new YAML.load_file(CONFIG)
  trap("INT"){ bot.quit }
  bot.run
end
