class Media < ActiveRecord::Base
  has_many :episodes, dependent: :destroy

  validates :source_url, presence: true

  mount_uploader :waveform, WaveformUploader
  mount_uploader :file,     AudioUploader

  def status
    stat = Sidekiq::Status::status(job_id)
    stat ||= :complete
    stat
  end
end
