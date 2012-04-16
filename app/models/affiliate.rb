class Affiliate < ActiveRecord::Base
  belongs_to :user
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  attr_accessible :first_name, :last_name, :company, :address, :city, :state, :country, :zip_code, :phone

  class << self
    def affiliate_for_user(user)
      where(user_id: user.try(:id))
    end
  end
end