class TwitterCountry < ActiveRecord::Base
  has_many :twitter_states
  has_many :twitter_users

  attr_accessible :name

  validates :name, uniqueness: true, presence: true
end
