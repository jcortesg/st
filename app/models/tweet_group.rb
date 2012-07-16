class TweetGroup < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :influencer
  has_many :tweets, dependent: :destroy

  attr_accessible :campaign, :campaign_id, :influencer, :influencer_id, :tweets_attributes

  accepts_nested_attributes_for :tweets
end
