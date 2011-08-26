# encoding: utf-8
module SimpleBot
  class Quote < Sentence
    def self.random_by_search(query)
      regex = Regexp.new(query) rescue nil
      (regex ? find_by_regex(regex) : find_by_user(query)).sample
    end

    private
    def self.find_by_regex(regex)
      filter_sentences {|sentence| sentence =~ regex}
    end

    def self.find_by_user(query)
      user = query.split(" ").first
      filter_sentences {|sentence| sentence.match(/<#{user}>/)}
    end

    def self.filter_sentences(&block)
      self.file["#{self.class_name}s"].select(&block)
    end
  end
end

