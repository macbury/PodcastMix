class FiberHttp
  attr_accessor :response

  def initialize(url, options={ cache: true })
    @uri   = URI.parse(url)
    cache_key = ["html-xml-cache", @uri.to_s]

    if options[:content_type].nil?
      options[:content_type] = /(xml|atom|rss|rdf|text\/*)/i
    end

    @options      = options
    self.response = Rails.cache.read(cache_key) if @options[:cache]

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

      Rails.cache.write cache_key, response, expires_in: expire_date_by_status if @options[:cache]
    else
      Rails.logger.info "Loaded from cache: #{cache_key.inspect}"
    end
  end

  def expire_date_by_status
    if success?
      7.days
    else
      15.minutes
    end
  end

  def fetch
    fiber  = Fiber.current
    @http  = EventMachine::HttpRequest.new(@uri.to_s).get head: { user_agent: "PodcastMix" }, redirects: 10

    @http.headers do |headers| 
      Rails.logger.info "Headers: #{headers.inspect}"
      unless @options[:content_type] =~ headers["CONTENT_TYPE"]
        Rails.logger.info "Invalid content type: #{headers["CONTENT_TYPE"]}"
        self.response[:error] = "Invalid content type"
        @http.close 
      end
    end

    @http.callback do
      self.response[:uri]    = @http.last_effective_url
      self.response[:header] = @http.response_header
      self.response[:status] = @http.response_header.status
      self.response[:body]   = @http.response
      Rails.logger.info "Recived response: #{self.response[:status]}"
      fiber.resume(@http)
    end

    @http.errback do
      self.response[:error] ||= @http.error
      fiber.resume(@http)
    end

    Fiber.yield
  end

  def binary
    @binary                   = FilelessIO.new(self.response_text)
    @binary.original_filename = File.basename(uri.path)
    Rails.logger.debug "File: #{@binary.original_filename}"
    @binary
  end

  def uri
    self.response[:uri]
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

  def is_feed?
    response_document.css("rss, channel").size > 0
  end

  def is_html?
    response_document.css("html, head").size > 0
  end
end