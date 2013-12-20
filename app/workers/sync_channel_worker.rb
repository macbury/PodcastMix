require 'shellwords'

class SyncChannelWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: :rss
  recurrence { hourly }

  def perform(channel_id)
    channel                   = Channel.find(channel_id)
    channel.last_update       = nil
    channel.remote_poster_url = channel.poster_source_url if channel.poster.exists?
    channel.save

    feed    = Feedzirra::Feed.fetch_and_parse(channel.source_url)

    if feed != 200
      feed.sanitize_entries!
      feed.entries.each do |entry|
        if entry.enclosure_url.present?
          episode = channel.episodes.find_or_initialize_by(guid: entry.entry_id)
          create_episode(episode, entry) if episode.new_record?
        end
      end
    end

    channel.update_attributes last_update: Time.now
  end

  def create_episode(episode, entry)
    episode.title         = entry.title
    episode.description   = entry.summary.strip
    episode.link          = entry.url
    episode.published_at  = entry.published

    if entry.enclosure_url.present?
      url = URI.parse(entry.enclosure_url)
      url.scheme = "http" if url.scheme.nil?

      media           = Media.find_or_initialize_by(source_url: url.to_s)
      should_download = media.new_record?
      episode.media   = media
      if episode.save && should_download
        media.save
        job_id = MediaDownloaderWorker.perform_async(media.source_url, media.id)
        media.update_column("job_id", job_id)
      end
    end
  end
end