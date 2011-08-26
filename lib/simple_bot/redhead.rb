# encoding: utf-8
module SimpleBot
  class Redhead
    ENDPOINT = "http://fuckyeahredhair.tumblr.com/api/read?num=50&type=photo"

    class << self
      def fetch(fetcher=HTTParty)
        response = fetcher.get(ENDPOINT)

        document = Nokogiri::XML(response.body)
        biggest_pictures(posts(document)).sample
      end

      private

      def posts(document)
        document.xpath('//post')
      end

      def biggest_pictures(posts)
        posts.map do |post_node|
          biggest_picture(post_node).text
        end
      end

      def biggest_picture(node)
        node.xpath("//photo-url").sort_by do |photo|
          photo['max-width'].to_i
        end.last
      end
    end
  end
end
