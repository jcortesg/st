# encoding: utf-8
class Advertiser < ActiveRecord::Base
  has_many :tweets
  has_many :campaigns
  has_many :competitors, :as => :advertisers
  has_many :competitors, :as => :competitors
  belongs_to :user

  validates :company, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  attr_accessible :first_name, :last_name, :twitter_username, :company, :address, :city, :state, :country, :zip_code, :phone

end