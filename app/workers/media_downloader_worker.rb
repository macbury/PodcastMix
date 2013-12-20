require 'shellwords'
require 'mime/types'

class MediaDownloaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :media
  
  def assign_jid(media_id)
    media = Media.where(id: media_id).first
    media.update_column("job_id", jid) if media
  end

  def perform(source_url, media_id)
    assign_jid(media_id)
    begin
      mp3_temp_file         = Tempfile.new(['audio', ".mp3"])
      spectogram_temp_file  = Tempfile.new(['spectogram', ".png"])

      shell "wget -O #{mp3_temp_file.path} #{Shellwords.escape(source_url)}"

      mime_type = shell("file --mime-type #{mp3_temp_file.path}").split(":")[1].strip
      throw "Mime type is invalid: #{mime_type}" unless mime_type =~ /audio\/mpeg|application\/octet-stream/i

      hash      = md5(mp3_temp_file.path).hexdigest
      throw "Hash is nil or empty" if hash.nil? || hash.empty?

      cached_media = Media.where("hash_sum = :hash AND id != :id", hash: hash, id: media_id).first

      if cached_media
        Episode.where(media_id: media_id).update_all(media_id: cached_media.id)
      else
        shell "#{Rails.root.join("bin/waveform")} #{mp3_temp_file.path} #{spectogram_temp_file.path} --width 1980 --height 90" if mp3_temp_file.size > 0
        media = Media.find(media_id)
        if mp3_temp_file.size > 0
          media.hash_sum  = hash
          media.size      = mp3_temp_file.size
          media.waveform  = spectogram_temp_file
          media.file      = mp3_temp_file
          media.mime_type = mime_type
          media.duration  = shell("soxi -D #{mp3_temp_file.path}").to_f
          media.save!
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e.to_s 
      Rails.logger.error media.inspect
    ensure
      mp3_temp_file.close
      mp3_temp_file.unlink
      spectogram_temp_file.close
      spectogram_temp_file.unlink
    end    
  end

  def md5(path)
    File.open(path, 'rb') do |io|
      dig = Digest::MD5.new
      buf = ""
      dig.update(buf) while io.read(4096, buf)
      dig
    end
  end

  def shell(cmd)
    Rails.logger.info     cmd
    output                = `#{cmd}`
    Rails.logger.info     output
    output
  end
end