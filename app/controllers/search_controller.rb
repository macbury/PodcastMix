class SearchController < ApplicationController
  respond_to :json

  def show
    @page = PageAnalyzer.new(param_query)

    if @page.success?
      render text: @page.is_html?
    else
      render text: @page.error
    end
  end

  protected

  def param_query
    params.require(:query)
  end
end