class SearchController < ApplicationController
  respond_to :html

  def show
    @channels = Channel.limit(25).search(param_query)

   if @channels.size == 0
      begin
        download_page_or_feed
      rescue Addressable::URI::InvalidURIError => e
        Rails.logger.error "Parse query error: #{param_query} => #{e.to_s}"
      rescue URI::InvalidURIError => e
        Rails.logger.error "Parse query error: #{param_query} => #{e.to_s}"
      end
    end

    @channels.compact!

    if @channels.size == 1
      redirect_to @channels[0]
    end
  end

  protected

    def download_page_or_feed
      @request = FiberHttp.new(param_query)
      if @request.success?
        if @request.is_feed?
          download_feed_or_parse(@request)
        elsif @request.is_html?
          @page = PageImporter.new(@request.uri, @request.response_document)
          @page.feeds.each do |feed|
            download_feed_or_parse(feed.url)
          end
        end
      end
    end

    def download_feed_or_parse(url)
      if url.class == FiberHttp
        request = url
      else
        request = FiberHttp.new(url) 
      end

      if request.success? && request.is_feed?
        begin
          channel = Channel.by_url(request.uri.to_s).first
          @channels << channel
          return if channel

          parser  = Feedzirra::Feed.parse(request.response_text)
          if parser.class == Feedzirra::Parser::ITunesRSS
            channel = Channel.new
            channel.build_using_parser_and_request!(parser, request)
            @channels << channel if channel.valid?
          else
            Rails.logger.info "URL: #{url} is not iTunes Feed"
          end
        rescue Feedzirra::NoParserAvailable => e
          Rails.logger.error "Parse feed error: #{url} => #{e.to_s}"
        end
      end
    end

    def param_query
      query = params[:query]
      query = "-1-" if query.nil? || query.empty?
      query
    end
end