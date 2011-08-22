# encoding: utf-8
class SimpleIrcBot
  class Quote
    QUOTES_PATH = File.expand_path(File.dirname(__FILE__))+"/../../speak/quotes.yml"

    attr_reader :quote

    def initialize(quote)
      @quote = quote
    end

    def add!
      quotes = self.class.file
      quotes[:quotes] << quote
      File.open(QUOTES_PATH, "w"){|f| YAML.dump(quotes, f)}
    end

    def self.random
      self.file[:quotes][rand(self.file[:quotes].size)]
    end

    def self.file
      YAML.load_file(QUOTES_PATH)
    end
  end
end
