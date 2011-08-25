# encoding: utf-8
module SimpleIrcBot
  class Phrase
    attr_reader :phrase

    def initialize(phrase)
      @phrase = phrase
    end

    def add!
      phrases_path = File.expand_path(File.dirname(__FILE__))+"/../../talk_files/#{self.class.class_name}.yml"
      phrases = self.class.file
      p "#{self.class.class_name}s"
      phrases["#{self.class.class_name}s"] << phrase
      File.open(phrases_path, "w"){|f| YAML.dump(phrases, f)}
    end

    def self.random
      phrases = self.file["#{self.class_name}s"]
      phrases[rand(phrases.size)]
    end

    def self.file
      phrases_path = File.expand_path(File.dirname(__FILE__))+"/../../talk_files/#{self.class_name}.yml"
      YAML.load_file(phrases_path)
    end

    def self.class_name
      self.name.gsub(/.*::(\w)/,"\\1").downcase.to_sym
    end
  end
end
