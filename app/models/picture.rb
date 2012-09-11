require 'file_size_validator'

class Picture < ActiveRecord::Base
  attr_accessible :image, :picture_code

  mount_uploader :image, ImageUploader
end
