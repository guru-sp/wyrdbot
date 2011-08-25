# encoding: utf-8
module SimpleIrcBot
  class Quote < Phrase
    attr_reader :phrase

    def self.random_by_user(query)
      user = query.split(" ").first
      user_phrases = self.file[:phrases].select do |phrase|
        phrase.match(/<#{user}>/)
      end
      user_phrases[rand(user_phrases.size)]
    end
  end
end

