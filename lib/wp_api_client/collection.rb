module WpApiClient
  class Collection
    include Enumerable

    attr_accessor :resources, :total_available

    def initialize(resources, headers = nil)
      resources = [resources] unless resources.is_a? Array
      @resources = resources.map { |object| WpApiClient::Entities::Base.build(object, self) }
      if headers
        @links = parse_link_header(headers['Link'])
        @total_available = headers['X-WP-TOTAL'].to_i
      end
    end

    def each(&block)
      @resources.each{|p| block.call(p)}
    end

    def next_page
      @links[:next] && @links[:next]
    end

    def previous_page
      @links[:prev] && @links[:prev]
    end

    def method_missing(sym)
      @resources.send(sym)
    end

private

    # https://www.snip2code.com/Snippet/71914/Parse-link-headers-from-Github-API-in-Ru
    def parse_link_header(header, params={})
      links = Hash.new
      return links unless header
      parts = header.split(',')
      parts.each do |part, index|
        section = part.split(';')
        url = section[0][/<(.*)>/,1]
        name = section[1][/rel="(.*)"/,1].to_sym
        links[name] = url
      end
      return links
    end
  end
end
