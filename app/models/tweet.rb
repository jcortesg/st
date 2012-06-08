# encoding: utf-8
class Tweet < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :influencer
  has_many :clicks

  attr_accessible :campaign_id, :influencer_id, :text, :link_url, :fee_type, :tweet_at

  validates :campaign_id, presence: true
  validates :influencer_id, presence: true
  validates :fee_type, presence: true
  validates :text, presence: true
  validate :text_contains_link

  # Tweet status:
  # * created: Created by the advertiser
  # * influencer_reviewed: Revised by the Influencer
  # * influencer_rejected: Rejected by the Influencer
  # * advertiser_reviewed: Revised by the Advertiser
  # * advertiser_rejected: Rejected by the Advertiser
  # * accepted: Accepted either by advertiser or influencer

  state_machine :status, initial: :created do
    event :reviewed_by_influencer do
      transition [:created, :advertiser_reviewed, :advertiser_rejected] => [:influencer_reviewed]
    end

    event :reviewed_by_advertiser do
      transition [:influencer_reviewed] => [:advertiser_reviewed]
    end

    event :accepted_by_influencer do
      transition [:created, :advertiser_reviewed, :influencer_reviewed] => [:accepted]
    end

    event :accepted_by_advertiser do
      transition [:influencer_reviewed] => [:accepted]
    end

    event :rejected_by_influencer do
      transition [:created, :advertiser_reviewed] => [:influencer_rejected]
    end

    event :rejected_by_advertiser do
      transition [:influencer_reviewed] => [:advertiser_rejected]
    end
  end

  def cost
    "AR$ 0.0"
  end

  def text_contains_link
    matches = text.scan(/\b(?:https?:\/\/|www\.)\S+\b/)
    if matches.size == 0
      errors.add(:text, "no tiene ningún link")
    elsif matches.size > 1
      errors.add(:text, "tiene más de un link")
    end
  end
end
