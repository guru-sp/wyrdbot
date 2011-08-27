# encoding: utf-8
module SimpleBot
  class Pr0n
    def self.search(query)
      # video = Redtube::Video.search(query.to_s).sample
      # "#{video.title} - #{video.url} *fap* *fap* *fap*"
      "Ahh safadinho! Ta querendo pornografia né?"
    rescue Exception => error
    end
  end
end
