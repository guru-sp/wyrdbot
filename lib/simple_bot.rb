# encoding: utf-8
require "yaml"
require "socket"
require "open-uri"
require "json"
require "logger"
require "daemons"
require "pathname"

require "simple_bot/logger"
require "simple_bot/ed_robot"
require "simple_bot/google"
require "simple_bot/greetings"
require "simple_bot/utils"
require "simple_bot/flame_war"
require "simple_bot/phrase"
require "simple_bot/quote"
require "simple_bot/motorcycle"
require "simple_bot/simple_bot"
require "simple_bot/redhead"

module SimpleBot
  def self.root
    @root ||= Pathname.new(File.expand_path("../..", __FILE__))
  end
end
