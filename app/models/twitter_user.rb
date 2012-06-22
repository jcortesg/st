class TwitterUser < ActiveRecord::Base
  belongs_to :twitter_country
  belongs_to :twitter_state

  attr_accessible :screen_name, :twitter_country_id, :twitter_state_id, :male, :female,
                  :sports, :fashion, :music, :movies, :politics, :technology, :travel, :luxury

  validates :screen_name, uniqueness: true, presence: true
end
