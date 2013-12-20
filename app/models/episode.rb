class Episode < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to  :channel
  belongs_to  :media

  validates :title, :description, :published_at, :link, :guid, presence: true
end
