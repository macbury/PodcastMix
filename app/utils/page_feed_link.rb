require 'digest/sha1'
class PageFeedLink

  def initialize(base_url, feed_url, title)
    parent_uri = URI.parse(base_url)
    @uri       = URI.parse(feed_url)

    [:scheme, :host].each do |a|
      @uri.send("#{a.to_s}=", parent_uri.send(a)) if @uri.send(a).nil?
    end

    @title     = title  
  end

  def title
    @title
  end

  def hash
    Digest::SHA1.hexdigest url.gsub(/[^A-Z0-9]/i, "")
  end

  def url
    @uri.to_s
  end

  def inspect
    "<PageFeedLink title=#{title} url=#{url} hash=#{hash}>"
  end
end