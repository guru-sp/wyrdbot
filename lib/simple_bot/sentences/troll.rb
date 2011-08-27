# encoding: utf-8
module SimpleBot
  class Troll < Sentence
    def self.random_to(nick)
      "#{nick}, #{random}"
    end
  end
end
