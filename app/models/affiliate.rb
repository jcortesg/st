# encoding: utf-8
class Affiliate < ActiveRecord::Base
  belongs_to :user

  has_attached_file :photo, :styles => { :profile => "140x140#", :small => "100x100>", :thumb => "48x48#"  }

  before_save :normalize_fields
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  attr_accessible :first_name, :last_name, :company, :address, :city, :state, :country, :zip_code, :phone,
                  :location, :image_url, :bio, :influencer_type, :birthday, :photo, :sex,
                  :description, :referrer_description, :address, :city, :state, :country, :zip_code, :phone,
                  :cell_phone, :contact_time, :contact_method, :preferred_payment, :account_number, :account_type, :cbu,
                  :bank_name, :position, :brand, :twitter_screen_name, :web

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

  private

  def normalize_fields
    unless self.twitter_screen_name.blank?
      self.twitter_screen_name = self.twitter_screen_name.tr('@', '')
    end
  end
end