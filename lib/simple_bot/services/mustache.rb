# encoding: utf-8
module SimpleBot
  module Mustache
    def mustachify(query)
      "http://mustachify.me/?src=#{SimpleBot::Google.search_image(query)}"
    end
  end
end