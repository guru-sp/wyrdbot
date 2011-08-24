# encoding: utf-8
module SimpleIrcBot
  class Phrase
    PHRASES_PATH = File.expand_path(File.dirname(__FILE__))+"/../../speak/quotes.yml"

    attr_reader :phrase

    def initialize(phrase)
      @phrase = phrase
    end

    def add!
      phrases = self.class.file
      phrases[:quotes] << phrase
      File.open(PHRASES_PATH, "w"){|f| YAML.dump(phrases, f)}
    end

    def self.random
      self.file[:quotes][rand(self.file[:quotes].size)]
    end

    def self.random_by_user(query)
      user = query.split(" ").first
      user_phrases = self.file[:phrases].select do |phrase|
        phrase.match(/<#{user}>/)
      end
      user_phrases[rand(user_phrases.size)]
    end

    def self.file
      YAML.load_file(PHRASES_PATH)
    end
  end
end
