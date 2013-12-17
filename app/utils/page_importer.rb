class PageImporter

  def initialize(base_url, doc)
    @doc   = doc
    @feeds = []
    @doc.css("head link[type='application/rss+xml']").each do |link|
      @feeds << PageFeedLink.new(base_url, link["href"], link["title"])
    end
  end

  def feeds
    @feeds
  end
end