class Profile < ActiveRecord::Base
  belongs_to :influencer
  
  def self.profile_for_influencer_id_and_for_date(influencer_id, date)
    self.select("profiles.*, influencers.borwin_fee").joins(:influencer).where(['influencer_id = ? AND created_at <= ?', influencer_id, date]).
      order("created_at DESC").first
  end
end