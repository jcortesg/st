# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file
  process :convert => 'jpg'

  process :resize_to_fit => [1000, 1000]
  	
  version :thumb do
    process :resize_to_fit => [100, 100]
  end
  
  def extension_white_list
  	%w(jpg jpeg gif png)
  end
  
  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  def store_dir
    "bwn-image/"
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path) + Time.now.to_s)
      "#{@name}.#{file.extension}"
    end
  end
end
