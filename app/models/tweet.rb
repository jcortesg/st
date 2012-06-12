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
  validate :tweet_text_validation

  after_create :mail_tweet_creation
  before_create :set_prices
  before_create :create_borwin_link

  # Tweet status:
  # * created: Created by the advertiser
  # * influencer_reviewed: Revised by the Influencer
  # * influencer_rejected: Rejected by the Influencer
  # * advertiser_reviewed: Revised by the Advertiser
  # * advertiser_rejected: Rejected by the Advertiser
  # * accepted: Accepted either by Advertiser or Influencer
  # * active: The tweet was tweeted on twitter

  state_machine :status, initial: :created do
    #after_transition on: [:created], do: :mail_tweet_creation
    after_transition on: [:reviewed_by_advertiser], do: :mail_reviewed_by_advertiser
    after_transition on: [:reviewed_by_influencer], do: :mail_reviewed_by_influencer
    after_transition on: [:accepted_by_advertiser], do: :mail_accepted_by_advertiser
    after_transition on: [:accepted_by_influencer], do: :mail_accepted_by_influencer
    after_transition on: [:rejected_by_advertiser], do: :mail_rejected_by_advertiser
    after_transition on: [:rejected_by_influencer], do: :mail_rejected_by_influencer
    after_transition on: [:activate], do: :mail_tweet_activated

    event :reviewed_by_advertiser do
      transition [:influencer_reviewed] => [:advertiser_reviewed]
    end

    event :reviewed_by_influencer do
      transition [:created, :advertiser_reviewed, :advertiser_rejected] => [:influencer_reviewed]
    end

    event :accepted_by_advertiser do
      transition [:influencer_reviewed] => [:accepted]
    end

    event :accepted_by_influencer do
      transition [:created, :advertiser_reviewed, :influencer_reviewed] => [:accepted]
    end

    event :rejected_by_advertiser do
      transition [:influencer_reviewed] => [:advertiser_rejected]
    end

    event :rejected_by_influencer do
      transition [:created, :advertiser_reviewed] => [:influencer_rejected]
    end

    event :activate do
      transition [:accepted] => [:activated]
    end
  end

  # Check that the text contains a link
  def tweet_text_validation
    matches = text.scan(/\b(?:https?:\/\/|www\.)\S+\b/)
    if matches.size == 0
      errors.add(:text, "no tiene ningún link")
    elsif matches.size > 1
      errors.add(:text, "tiene más de un link")
    else
      template_text = text.sub(/\b(?:https?:\/\/|www\.)\S+\b/, 'http://bwn.tw/L1234')
      if template_text.size > 157
        errors.add(:text, "tiene #{template_text.size} carácteres, el máximo es de 140")
      end
    end
  end

  private

  # Replaces the link on the text with a borwin link
  def create_borwin_link
    # Generate the link code
    o =  [('A'..'Z'),('a'..'z'),(0..9)].map{|i| i.to_a}.flatten
    begin
      code = (0..3).map{ o[rand(o.length)] }.join
    end while Tweet.where(link_code: code).exists?

    # Now parse and create the data
    self.link_code = code

    # Get the link from the tweet
    matches = text.scan(/\b(?:https?:\/\/|www\.)\S+\b/)
    self.link_url = matches[0]
    self.link_url = "http://#{self.link_url}" unless self.link_url =~ /http/

    # Finally replace the text link on the text
    self.text.sub!(/\b(?:https?:\/\/|www\.)\S+\b/, "http://bwn.tw/L#{self.link_code}")
  end

  # Set the prices for the tweet when its created
  def set_prices
    if self.influencer
      self.tweet_fee = influencer.tweet_fee
      self.cpc_fee = influencer.cpc_fee
    end
  end

  # Sends a mail when the tweet was created by the advertiser
  def mail_tweet_creation
    Notifier.tweet_creation(self).deliver
  end

  # Sends a mail when the tweet has been reviewed by the advertiser
  def mail_reviewed_by_advertiser
    Notifier.tweet_reviewed_by_advertiser(self).deliver
  end

  # Sends a mail when the tweet has been reviewed by the influencer
  def mail_reviewed_by_influencer
    Notifier.tweet_reviewed_by_influencer(self).deliver
  end

  # Sends a mail when the tweet has been accepted by the advertiser
  def mail_accepted_by_advertiser
    Notifier.tweet_accepted_by_advertiser(self).deliver
  end

  # Sends a mail when the tweet has been accepted by the influencer
  def mail_accepted_by_influencer
    Notifier.tweet_accepted_by_influencer(self).deliver
  end

  # Sends a mail when the tweet has been rejected by the advertiser
  def mail_rejected_by_advertiser
    Notifier.tweet_rejected_by_advertiser(self).deliver
  end

  # Sends a mail when the tweet has been rejected by the influencer
  def mail_rejected_by_influencer
    Notifier.tweet_rejected_by_influencer(self).deliver
  end

  # Sends a mail when the tweet has been published
  def mail_tweet_activated
    Notifier.tweet_activated_to_advertiser(self).deliver
    Notifier.tweet_activated_to_influencer(self).deliver
  end
end
