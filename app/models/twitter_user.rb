class TwitterUser < ActiveRecord::Base
  belongs_to :twitter_country
  belongs_to :twitter_state
  has_many :twitter_followers
  has_many :influencers, through: :twitter_followers

  attr_accessible :twitter_uid, :twitter_screen_name, :twitter_country_id, :twitter_state_id, :male, :female,
                  :sports, :fashion, :music, :movies, :politics, :technology, :travel, :luxury, :influencers,
                  :location, :profile_image_url, :followers, :friends, :tweets

  validates :twitter_uid, uniqueness: true, presence: true
end
