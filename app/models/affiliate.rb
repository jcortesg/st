# encoding: utf-8
class Affiliate < ActiveRecord::Base
  belongs_to :user
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  attr_accessible :first_name, :last_name, :company, :address, :city, :state, :country, :zip_code, :phone

end