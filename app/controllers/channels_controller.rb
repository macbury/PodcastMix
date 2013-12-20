class ChannelsController < ApplicationController
  before_filter :set_channel, except: [:index]

  def show
    
  end

  def poster
    if !@channel.poster.present? && @channel.poster_source_url.present?
      Rails.logger.info "Configuring poster: #{@channel.poster_source_url}"
      @request = FiberHttp.new(@channel.poster_source_url, content_type: /(png|jpg|jpeg|octet-stream)/i, cache: false)
      if @request.success?
        @channel.poster.store!(@request.binary)
        @channel.save
      end
    end

    redirect_to @channel.poster.url(params[:size]), status: :moved_permanently
  end

  protected
    def set_channel
      @channel = Channel.find_by!(slug: params[:id])
    end
end