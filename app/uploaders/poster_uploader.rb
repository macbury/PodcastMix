# encoding: utf-8

class PosterUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  
  def store_dir
    "channels/#{model.slug}/#{mounted_as}/"
  end

  process :resize_to_fit => [512, 512]

  version :thumb do
    process :resize_to_fit => [128, 128]
  end

  version :poster do
    process :resize_to_fit => [256, 256]
  end

  def default_url
    ActionController::Base.helpers.image_path("channel/"+[version_name, "default.png"].compact.join('_'))
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
