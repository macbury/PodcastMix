class SearchController < ApplicationController
  respond_to :json

  def show
    # first search in db next fetch http
    if param_query =~ URI::regexp
      download_page_or_feed
    else
      render text: "Search in db feed"
    end
  end

  def download_page_or_feed
    @request = FiberHttp.new(param_query)

    if @request.success?
      if @request.is_html?
        @page = PageImporter.new(@request.uri, @request.response_document)
        render text: @page.feeds.inspect
      elsif @request.is_feed?
        render text: "Is feed"
      else
        render text: "No feeds found"
      end
    else
      render text: @request.error
    end
  end

  protected

  def param_query
    params.require(:query)
  end
end