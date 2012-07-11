class Hashtag < ActiveRecord::Base
  belongs_to :campaign
  # attr_accessible :title, :body
end
