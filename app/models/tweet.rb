# encoding: utf-8
class Tweet < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :influencer
  belongs_to :tweet_group
  belongs_to :referrer
  has_many :clicks, dependent: :destroy
  has_many :retweets, dependent: :destroy

  attr_accessible :campaign_id, :influencer_id, :text, :link_url, :fee_type, :tweet_at, :reject_cause

  validates :campaign_id, presence: true
  validates :influencer_id, presence: true
  validates :fee_type, presence: true
  validates :text, presence: true
  validate :tweet_text_validation
  validate :tweet_at_validation

  after_create :mail_tweet_creation
  after_create :update_picture_references
  before_create :set_prices
  before_create :create_borwin_link

  # Tweet status:
  # * created: Created by the advertiser
  # * influencer_reviewed: Revised by the Influencer
  # * influencer_rejected: Rejected by the Influencer
  # * advertiser_reviewed: Revised by the Advertiser
  # * advertiser_rejected: Rejected by the Advertiser
  # * expired: Expired because noone accepted it
  # * accepted: Accepted either by Advertiser or Influencer
  # * active: The tweet was tweeted on twitter

  state_machine :status, initial: :created do
    #after_transition on: [:created], do: :mail_tweet_creation
    after_transition on: [:advertiser_review], do: :mail_reviewed_by_advertiser
    after_transition on: [:influencer_review], do: :mail_reviewed_by_influencer
    after_transition on: [:advertiser_accept], do: :create_hashtags_and_mail_accepted_by_advertiser
    after_transition on: [:influencer_accept], do: :create_hashtags_and_mail_accepted_by_influencer
    after_transition on: [:advertiser_reject], do: :mail_rejected_by_advertiser
    after_transition on: [:influencer_reject], do: :mail_rejected_by_influencer
    after_transition on: [:activate], do: :activate_and_mail_tweet_activated
    after_transition on: [:advertiser_accept, :influencer_accept], do: :create_fee_for_tweet

    event :advertiser_review do
      transition [:influencer_reviewed] => [:advertiser_reviewed]
    end

    event :influencer_review do
      transition [:created, :advertiser_reviewed, :advertiser_rejected] => [:influencer_reviewed]
    end

    event :advertiser_accept do
      transition [:influencer_reviewed] => [:accepted]
    end

    event :influencer_accept do
      transition [:created, :advertiser_reviewed, :influencer_reviewed] => [:accepted]
    end

    event :advertiser_reject do
      transition [:influencer_reviewed] => [:advertiser_rejected]
    end

    event :influencer_reject do
      transition [:created, :advertiser_reviewed] => [:influencer_rejected]
    end

    event :activate do
      transition [:accepted] => [:activated]
    end

    event :expire do
      transition [:advertiser_reviewed, :influencer_reviewed, :created] => [:expired]
    end
  end

  class << self
    # Gets all the published tweets
    def activated
      where(status: 'activated')
    end

    # Expired tweets
    def expired
      where(status: 'expired')
    end
  end

  # Check that the text contains a link
  def tweet_text_validation
    matches = text.scan(/\b(?:https?:\/\/|www\.)\S+\b/)
    #if matches.size == 0
    #  errors.add(:text, "no tiene ningún link")
    #elsif matches.size > 1
    if matches.size > 2
      errors.add(:text, "tiene más de un link")
    else
      template_text = text.sub(/\b(?:https?:\/\/|www\.)\S+\b/, 'http://s-t.co/L1234')
      if template_text.size > 157
        errors.add(:text, "tiene #{template_text.size} carácteres, el máximo es de 140")
      end
    end
  end

  # Check the date of the tweet, it has to be in the future with a least 1 hour of creation from now
  def tweet_at_validation
    #if self.tweet_at < (Time.now + 1.hour)
    #  errors.add(:tweet_at, "debe ser a partir de la próxima hora en adelante")
    #end
  end


  # Creates the transaction when a tweet is accepted
  def create_fee_for_tweet
    # First lets get the advertiser and the influencer
    advertiser = self.campaign.advertiser
    influencer = self.influencer

    # Now get the referrers and their commission
    advertiser_referrer = advertiser.user.referrer
    advertiser_referrer_commission = advertiser.user.referrer_commission
    advertiser_referrer_fee = 0
    influencer_referrer = influencer.user.referrer
    influencer_referrer_commission = influencer.user.referrer_commission
    influencer_referrer_fee = 0


    # Calculate the fees for the advertiser, influencer and borwin
    tweet_fee = self.tweet_fee
    influencer_tweet_fee = self.influencer_tweet_fee
    borwin_fee = tweet_fee - influencer_tweet_fee

    # Calculate if there is any feee for the referrers
    if advertiser_referrer
      advertiser_referrer_fee = (influencer_tweet_fee * (advertiser_referrer_commission.to_f / 100.0)).round(2)
      advertiser_referrer_fee = 0.01 if advertiser_referrer_fee < 0.01
    end
    if influencer_referrer
      influencer_referrer_fee = (influencer_tweet_fee * (influencer_referrer_commission.to_f / 100.0)).round(2)
      influencer_referrer_fee = 0.01 if influencer_referrer_fee < 0.01
    end

    # Finally get the borwin fee after the influencer and affiliate fees
    borwin_fee = borwin_fee - advertiser_referrer_fee - influencer_referrer_fee


    # First lets create the transaction to take the money from the advertiser
    Transaction.create(user: advertiser.user, transaction_at: Time.now,
                       transaction_type: 'tweet_fee', amount: tweet_fee * -1, attachable: self)
    # Create the earnings for the influencer
    Transaction.create(user: influencer.user, transaction_at: Time.now,
                       transaction_type: 'tweet_revenue', amount: influencer_tweet_fee, attachable: self)
    # Create the borwin fee
    Transaction.create(borwin_transaction: true, transaction_at: Time.now,
                       transaction_type: 'tweet_borwin_fee', amount: borwin_fee, attachable: self)
    # Create the fee for the advertiser referrer
    if advertiser_referrer
      Transaction.create(user: advertiser_referrer, transaction_at: Time.now,
                         transaction_type: 'advertiser_referrer_fee', amount: advertiser_referrer_fee, attachable: self,
                         referrer_id: self.campaign.advertiser.user_id)
    end
    # Create the fee for the influencer referrer
    if influencer_referrer
      Transaction.create(user: influencer_referrer, transaction_at: Time.now,
                         transaction_type: 'influencer_referrer_fee', amount: influencer_referrer_fee, attachable: self,
                         referrer_id: self.influencer_id)
    end
  end

  # Fetchs the retweets for the campaign tweets
  def fetch_retweets
    Campaign.twitter_connection

    #page = 1
    #begin
    #  tweets = Twitter.search("http://s-t.co/L#{self.link_code}", page: page, rpp: 100)
    #  tweets.each {|t| insert_retweet(t)}
    #  while tweets.count == 100 do
    #    tweets = Twitter.search("http://s-t.co/L#{self.link_code}", page: page, rpp: 100)
    #    tweets.each {|t| insert_retweet(t)}
    #  end
    #rescue Exception => e
    #  Rails.logger.warning("There was a problem fetching retweets for Tweet #{self.id}")
    #end

    retweets = Twitter.retweets(self.twitter_id, count: 100)
    retweets.each {|r| insert_retweet(r)}



    Campaign.twitter_connection

    twitter_tweet = Twitter.status(self.twitter_id)
    self.retweet_count = twitter_tweet.retweet_count
    self.save

    twitter_tweet.retweet_count
  end

  # Creates a retweet if it doesn't exists
  def insert_retweet(tweet)
    if tweet.attrs['id_str'] != self.twitter_id
      retweet = Retweet.find_or_create_by_twitter_id(tweet.attrs['id_str'])
      retweet.tweet_id = self.id
      #retweet.twitter_screen_name = tweet.attrs['from_user']
      #retweet.twitter_image_url = tweet.attrs['profile_image_url']

      # Remove if the retweet api is not used
      retweet.twitter_id = tweet.attrs['id_str']
      retweet.twitter_created_at = tweet.attrs['created_at']
      retweet.twitter_screen_name = tweet.attrs['user']['screen_name']
      retweet.twitter_retweet_count = tweet.attrs['retweet_count']
      retweet.twitter_friends_count = tweet.attrs['user']['friends_count']
      retweet.twitter_followers_count = tweet.attrs['user']['followers_count']
      retweet.twitter_image_url = tweet.attrs['user']['profile_image_url']

      retweet.save
    end
  end

  # Replaces the link on the text with a borwin link
  def create_borwin_link
    # Generate the link code
    o =  [('A'..'Z'),('a'..'z'),(0..9)].map{|i| i.to_a}.flatten
    first_char = ''
    case APP_CONFIG['app_country']
      when 'AR'
        first_char = 'A'
      when 'CO'
        first_char = 'C'
      when 'MX'
        first_char = 'M'
    end
    begin
      code = first_char + (0..3).map{ o[rand(o.length)] }.join
    end while Tweet.where(link_code: code).exists?

    # Now parse and create the data
    self.link_code = code

    # Get the link from the tweet
    matches = text.scan(/\b(?:https?:\/\/|www\.)\S+\b/)
    idx = 0
    matches.each do |link|
      if !matches[idx].match(/^http:\/\/s-t.co\//)
        self.link_url = matches[idx]
        self.link_url = "http://#{self.link_url}" unless self.link_url =~ /http/
      end
      idx = idx + 1
    end

    # Finally replace the text link on the text
    # [^(s-t.co\/P)] avoid THIS!!!
    self.text.sub!(/\b((?:https?:\/\/(?!s-t)|www\.(?!s-t)))\S+\b/, "http://s-t.co/L#{self.link_code}")
  end

  # Set the prices for the tweet when its created
  def set_prices
    if self.influencer
      self.tweet_fee = influencer.tweet_fee
      self.cpc_fee = influencer.cpc_fee
      self.influencer_tweet_fee = influencer.influencer_tweet_fee
      self.influencer_cpc_fee = influencer.influencer_cpc_fee
    end
  end

  # Sends an expiration alert to the different users
  def send_expiration_alert(time)
    Notifier.expiration_alert_to_admin(self,time).deliver
    if self.status == 'advertiser_reviewed'
      Notifier.expiration_alert_to_advertiser(self,time).deliver
    else
      Notifier.expiration_alert_to_influencer(self,time).deliver
    end
  end

  # Sends a mail when the tweet was created by the advertiser
  def mail_tweet_creation
    Notifier.tweet_creation(self).deliver
    Notifier.tweet_creation_to_admin(self).deliver
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
  def create_hashtags_and_mail_accepted_by_advertiser
    create_hashtags
    Notifier.tweet_accepted_by_advertiser(self).deliver
  end

  # Sends a mail when the tweet has been accepted by the influencer
  def create_hashtags_and_mail_accepted_by_influencer
    create_hashtags
    Notifier.tweet_accepted_by_influencer(self).deliver
  end

  # Sends a mail when the tweet has been rejected by the advertiser
  def mail_rejected_by_advertiser
    Notifier.tweet_rejected_by_advertiser(self).deliver
  end

  # Sends a mail when the tweet has been rejected by the influencer
  def mail_rejected_by_influencer
    if self.campaign.dialog_campaign
      Notifier.tweet_rejected_by_influencer_in_dialog(self).deliver
    else
      Notifier.tweet_rejected_by_influencer(self).deliver
    end
  end

  # Sends a mail when the tweet has been published
  def activate_and_mail_tweet_activated
    puts "[INFO] Activación..."
    # Send emails
    if (Notifier.tweet_activated_to_advertiser(self).deliver rescue nil).nil?
      puts "[ERROR] No se pudo enviar el mail al anunciante"
    end
    if (Notifier.tweet_activated_to_influencer(self).deliver rescue nil).nil?
      puts "[ERROR] No se pudo enviar el mail a la celebridad"
    end
    puts "[SUCCESS] Activación completada!"
  end

  # Creates the hashtag for the campain
  def create_hashtags
    matches = text.scan(/\B#\w*[a-zA-Z]+\w*/)
    matches.each do |match|
      Hashtag.create(campaign_id: campaign_id, hashtag: match) unless Hashtag.where(campaign_id: campaign_id, hashtag: match).exists?
    end
  end

  def update_picture_references
    # updates picture links
    text.scan(/\bhttp:\/\/s-t.co\/P\S+\b/).each do |link|
      code = link.sub(/\bhttp:\/\/s-t.co\/P/, "")
      picture = Picture.find_all_by_picture_code(code).first
      picture.tweet = self
      picture.save
    end
  end
end
