# encoding: utf-8
module SimpleIrcBot
  class Quote < Phrase
    def self.random_by_user(query)
      user = query.split(" ").first
      user_phrases = self.file["#{self.class_name}s"].select do |phrase|
        phrase.match(/<#{user}>/)
      end
      user_phrases[rand(user_phrases.size)]
    end
  end
end

