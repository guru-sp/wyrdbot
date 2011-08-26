module SimpleBot
  class Pr0n
    def self.search(query)
      video = Redtube::Video.search(query.to_s).sample
      "#{video.title} - #{video.url} *fap* *fap* *fap*"
    rescue Exception => error
    end
  end
end
