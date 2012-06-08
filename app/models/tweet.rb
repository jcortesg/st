class Tweet < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :influencer
  has_many :clicks

  attr_accessible :campaign_id, :influencer_id, :text, :link_url, :fee_type, :tweet_at

  validates :campaign_id, presence: true
  validates :influencer_id, presence: true

  # Tweet status:
  # * created: Created by the advertiser
  # * influencer_revised: Revised by the Influencer
  # * influencer_accepted: Accepted by the Influencer
  # * influencer_rejected: Rejected by the Influencer
  # * advertiser_revised: Revised by the Advertiser
  # * advertiser_accepted: Accepted by the Advertiser
  # * advertiser_rejected: Rejected by the Advertiser
end
