# encoding: utf-8
class Advertiser < ActiveRecord::Base
  belongs_to :user

  validates :company, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  attr_accessible :first_name, :last_name, :twitter_username, :company, :address, :city, :state, :country, :zip_code, :phone
end