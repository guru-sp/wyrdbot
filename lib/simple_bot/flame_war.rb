# encoding: utf-8
module SimpleIrcBot
  module FlameWar
    extend self
    FLAMES_PATH = File.expand_path(File.dirname(__FILE__))+"/../../speak/flame_war.yml"

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
      YAML.load_file(FLAMES_PATH)
    end
  end
end
