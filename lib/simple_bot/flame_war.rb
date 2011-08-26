# encoding: utf-8
module SimpleBot
  module FlameWar
    extend self
    def flame_on(message)
      if on?
        words = message.downcase.gsub(/[^\w\s]/, "").split(/\s+/)
        flame_key = file.keys.sort.find {|key| words.include?(key)}
        random_by_key(flame_key) if flame_key
      end
    end

    def random_by_key(key)
      file[key][rand(self.file[key].size)]
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

    def file
      YAML.load_file(SimpleBot.root.join("talk_files/flame_war.yml"))
    end
  end
end
