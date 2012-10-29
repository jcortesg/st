require 'file_size_validator'

class Picture < ActiveRecord::Base
  belongs_to :tweet
  attr_accessible :image, :picture_code, :tweet_id, :blank_layout

  mount_uploader :image, ImageUploader
end
