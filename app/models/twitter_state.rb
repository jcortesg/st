class TwitterState < ActiveRecord::Base
  belongs_to :twitter_country
  has_many :twitter_users

  attr_accessible :twitter_country, :twitter_country_id, :name

  validates :name, uniqueness: true, presence: true
end
