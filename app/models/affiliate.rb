class Affiliate < ActiveRecord::Base
  belongs_to :user
  
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  
  def self.affiliate_for_user(user)
    return self.find_by_user_id(user.id)
  end
end