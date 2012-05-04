# encoding: utf-8
class Audience < ActiveRecord::Base
  belongs_to :influencer
  has_many :audience_locations
  has_many :locations, :through => :audience_locations
 
  def self.audience_for_influencer_id_and_for_date(influencer_id, date)
    self.select("audiences.*").where(['influencer_id = ? AND created_at <= ?', influencer_id, date]).order("created_at DESC").first
  end

  def self.current_audiences
    self.select("influencers.*, audiences.*").joins(:influencer).where("audiences.status = 'A'").order("created_at DESC")
  end
  
  def self.current_audience_for_influencer_id(influencer_id)
    self.select("influencers.*, audiences.*").joins(:influencer).where(['influencer_id = ?', influencer_id]).order("created_at DESC").first
  end  
  
  def self.audiences_for_influencer_id(influencer_id)
    self.find_all_by_influencer_id(influencer_id)
  end
end