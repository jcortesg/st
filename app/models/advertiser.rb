class Advertiser < ActiveRecord::Base
  has_many :tweets
  has_many :campaigns
  has_many :competitors, :as => :advertisers
  has_many :competitors, :as => :competitors
  belongs_to :user
  
  validates :twitter_username, :presence => true, :length => { :within => 3..50 }, :uniqueness => true
  validates :brand, :presence => true
    
  def self.advertiser_for_user(user)
    return self.find_by_user_id(user.id)
  end
end