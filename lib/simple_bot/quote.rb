# encoding: utf-8
module SimpleBot
  class Quote < Phrase
    def self.random_by_search(query)
      regex = Regexp.new(query) rescue nil
      (regex ? find_by_regex(regex) : find_by_user(query)).sample
    end

    private
    def self.find_by_regex(regex)
      filter_phrases {|phrase| phrase =~ regex}
    end

    def self.find_by_user(query)
      user = query.split(" ").first
      filter_phrases {|phrase| phrase.match(/<#{user}>/)}
    end

    def self.filter_phrases(&block)
      self.file["#{self.class_name}s"].select(&block)
    end
  end
end

