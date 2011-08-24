# encoding: utf-8
module SimpleIrcBot
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

    def self.random_by_user(query)
      user = query.split(" ").first
      user_quotes = self.file[:quotes].select do |quote|
        quote.match(/<#{user}>/)
      end
      user_quotes[rand(user_quotes.size)]
    end

    def self.file
      YAML.load_file(QUOTES_PATH)
    end
  end
end
