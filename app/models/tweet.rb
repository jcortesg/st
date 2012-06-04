class Tweet < ActiveRecord::Base
  belongs_to :campaign
  has_many :clicks

  attr_accessible :campaign_id, :text, :link_url, :fee_type

  # Tweet status:
  # * created: Created by the advertiser
  # * influencer_revised: Revised by the Influencer
  # * influencer_accepted: Accepted by the Influencer
  # * influencer_rejected: Rejected by the Influencer
  # * advertiser_revised: Revised by the Advertiser
  # * advertiser_accepted: Accepted by the Advertiser
  # * advertiser_rejected: Rejected by the Advertiser
end
