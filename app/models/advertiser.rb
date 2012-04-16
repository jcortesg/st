class Advertiser < ActiveRecord::Base
  has_many :tweets
  has_many :campaigns
  has_many :competitors, :as => :advertisers
  has_many :competitors, :as => :competitors
  belongs_to :user

  validates :company, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  attr_accessible :first_name, :last_name, :twitter_username, :company, :address, :city, :state, :country, :zip_code, :phone

  def self.advertiser_for_user(user)
    return self.find_by_user_id(user.id)
  end
end