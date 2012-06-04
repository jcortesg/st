# encoding: utf-8
class Advertiser < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns, dependent: :destroy

  validates :company, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  attr_accessible :first_name, :last_name, :twitter_username, :company, :address, :city, :state, :country, :zip_code,
                  :phone, :can_create_campaigns

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def to_s
    if company.blank?
      "#{self.first_name} #{self.last_name}"
    else
      self.company
    end
  end
end