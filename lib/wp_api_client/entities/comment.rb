module WpApiClient
  module Entities
    class Comment < Base
      alias :comment :resource

      def self.represents?(json)
        json.dig("_links", "self") and json["_links"]["self"].first["href"] =~ /wp\/v2\/comments/
      end

      def author_name
        comment["author_name"]
      end

      def parent
        comment["parent"]
      end

      def date
        Time.parse(comment["date_gmt"]) if comment["date_gmt"]
      end

      def content
        comment["content"]["rendered"]
      end
    end
  end
end
