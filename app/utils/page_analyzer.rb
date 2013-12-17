class PageAnalyzer
  attr_accessor :response

  def initialize(url)
    @uri   = URI.parse(url)
    cache_key = ["cached-page-response", @uri.to_s]

    self.response = Rails.cache.read(cache_key)

    if response.nil?
      Rails.logger.info "GET: #{@uri.to_s}"
      self.response ||= {
        uri:    @uri.to_s,
        status: 404,
        body:   nil,
        header: {},
        error:  nil
      }
      
      fetch

      Rails.cache.write cache_key, response, expires_in: 2.days
    else
      Rails.logger.info "Loaded from cache: #{cache_key.inspect}"
    end
  end

  def fetch
    fiber  = Fiber.current
    @http  = EventMachine::HttpRequest.new(@uri.to_s).get head: { user_agent: "PodcastMix" }

    @http.headers do |headers| 
      Rails.logger.info "CONTENT_TYPE: #{headers["CONTENT_TYPE"]}"
      unless /(atom|rss|rdf|text\/*)/i =~ headers["CONTENT_TYPE"]
        Rails.logger.info "Invalid content type: #{headers["CONTENT_TYPE"]}"
        self.response[:error] = "Invalid content type"
        @http.close 
      end
    end

    @http.callback do
      Rails.logger.info "Recived response"
      self.response[:uri]    = @http.last_effective_url
      self.response[:header] = @http.response_header
      self.response[:status] = @http.response_header.status
      self.response[:body]   = @http.response
      fiber.resume(@http)
    end

    @http.errback do
      self.response[:error] ||= @http.error
      fiber.resume(@http)
    end

    Fiber.yield
  end

  def error
    self.response[:error]
  end

  def success?
    self.response[:status] == 200
  end

  def response_text
    self.response[:body]
  end

  def response_document
    @doc ||= Nokogiri::HTML.parse(response_text)
  end

  def is_html?
    response_document.css("html, head, body").size == 3
  end

  def has_feeds?
    
  end
end