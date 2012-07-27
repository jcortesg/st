# encoding: utf-8
class Advertiser < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns, dependent: :destroy
  has_many :tweets, through: :campaigns

  has_attached_file :photo, :styles => { :profile => "140x140#", :small => "100x100>", :thumb => "48x48#"  }

  before_save :normalize_fields

  validates :company, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true

  attr_accessible :first_name, :last_name, :twitter_username, :company, :address, :city, :state, :country, :zip_code,
                  :phone, :can_create_campaigns, :position, :web, :advertising_source, :brand, :photo,
                  :twitter_screen_name

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