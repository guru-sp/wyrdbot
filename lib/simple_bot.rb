# encoding: utf-8
libs = ["yaml", "socket", "open-uri", "json", "logger", "daemons", "redtube", "pathname"]
libs.each {|file| require file}

require "simple_bot/flame_war"
require "simple_bot/greetings"
require "simple_bot/logger"

require "simple_bot/sentences/sentence"
Dir[File.dirname(__FILE__) + "/simple_bot/sentences/**/*.rb"].each {|file| require file}
Dir[File.dirname(__FILE__) + "/simple_bot/services/**/*.rb"].each {|file| require file}

require "simple_bot/bot"

module SimpleBot
  def self.root
    @root ||= Pathname.new(File.expand_path("../..", __FILE__))
  end
end
