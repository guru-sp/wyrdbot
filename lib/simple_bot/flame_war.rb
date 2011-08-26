# encoding: utf-8
module SimpleBot
  module FlameWar
    extend self
    def flame_on(message)
      if on?
        words = message.downcase.gsub(/[^\w\s]/, "").split(/\s+/)
        flame_key = all_sentences.keys.sort.find {|key| words.include?(key)}
        random_by_key(flame_key) if flame_key
      end
    end

    def random_by_key(key)
      all_sentences[key].sample
    end

    def on?
      @turned_on
    end

    def on!
      @turned_on = true
    end

    def off!
      @turned_on = false
    end

    def add(key, sentence)
      sentences = all_sentences || {}
      sentences[key] ||= []
      sentences[key] << sentence
      File.open(file_path, "w"){|f| YAML.dump(sentences, f)}
    end

    def file_path
      SimpleBot.root.join("talk_files/flame_war.yml")
    end

    def all_sentences
      YAML.load_file(file_path)
    end
  end
end
