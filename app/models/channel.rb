class Channel < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  validates :title, :slug, :website, :source_url, :hash_uid, presence: true
  validates :hash_uid, uniqueness: true

  scope :by_url, ->(url) { where(hash_uid: Channel.hash_url(url)) }
  scope :search, ->(query) { where("hash_uid = :hash OR title LIKE :query OR author LIKE :query", hash: Channel.hash_url(query), query: "#{query}%") }

  mount_uploader :poster, PosterUploader
  after_create   :sync!

  has_many :episodes, dependent: :destroy

  def slug_candidates
    [
      :title,
      [:id, :title]
    ]
  end

  def self.hash_url(url)
    Digest::SHA1.hexdigest(url.gsub(/[^A-Z0-9]/i, ""))
  end

  def build_using_parser_and_request!(parser, request)
    parser.sanitize_entries!
    self.hash_uid    = Channel.hash_url(request.uri.to_s)
    self.source_url  = request.uri.to_s
    self.title       = parser.title.sanitize if parser.title
    self.website     = parser.url
    self.description = parser.description.sanitize if parser.description
    self.author      = parser.itunes_author.sanitize if parser.itunes_author
    self.poster_source_url = parser.itunes_image if parser.itunes_image
    self.poster_source_url ||= parser.image.strip if parser.image
    self.save
  end

  def sync!
    SyncChannelWorker.perform_async(self.id)
  end
end
