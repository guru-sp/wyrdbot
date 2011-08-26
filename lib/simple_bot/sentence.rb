# encoding: utf-8
module SimpleBot
  class Sentence
    attr_reader :sentence

    def initialize(sentence)
      @sentence = sentence
    end

    def add!
      sentences_path = SimpleBot.root.join("talk_files/#{self.class.class_name}.yml")
      sentences = self.class.file
      sentences["#{self.class.class_name}s"] << sentence
      File.open(sentences_path, "w"){|f| YAML.dump(sentences, f)}
    end

    def self.random
      sentences = self.file["#{self.class_name}s"]
      sentences[rand(sentences.size)]
    end

    def self.file
      sentences_path = SimpleBot.root.join("talk_files/#{self.class_name}.yml")
      YAML.load_file(sentences_path)
    end

    def self.class_name
      self.name.gsub(/.*::(\w)/,"\\1").downcase.to_sym
    end
  end
end
