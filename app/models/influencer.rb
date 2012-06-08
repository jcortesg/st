# encoding: utf-8
class Influencer < ActiveRecord::Base
  belongs_to :user
  has_one :audience, dependent: :destroy
  has_many :tweets

  has_attached_file :photo, :styles => { :profile => "140x200#", :small => "100x100>", :thumb => "48x48#"  }

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :influencer_type, :presence => true

  before_create :update_twitter_data
  after_create :update_audience, :assign_default_prices

  attr_accessible :first_name, :last_name, :location, :image_url, :bio, :influencer_type, :birthday, :photo, :sex,
                  :description, :referrer_description, :address, :city, :state, :country, :zip_code, :phone,
                  :cell_phone, :contact_time, :contact_method, :preferred_payment, :account_number, :account_type, :cbu,
                  :bank_name, :manual_tweet_fee, :manual_cpc_fee, :automatic_tweet_fee, :automatic_cpc_fee


  class << self
    def influencer_types
      ["Actor", "Actriz", "Músico", "Deportista", "Conductor", "Periodista", "Modelo", "Mediático", "Artista", "Panelista", "Cheff", "Humorista", "Moda", "Twitteros", "Otros"]
    end
  end

  # User full name
  def full_name
  	"#{self.first_name} #{self.last_name}"
  end

  # Influencer CPC price
  def cpc_fee
    manual_cpc_fee.blank? ? automatic_cpc_fee : manual_cpc_fee
  end

  # Influencer Tweet price
  def tweet_fee
    manual_tweet_fee.blank? ? automatic_tweet_fee : manual_tweet_fee
  end

  # String presentation
  def to_s
    "#{self.last_name}, #{self.first_name}"
  end

  # Updates the twitter data
  def update_twitter_data
    twitter_username = user.twitter_screen_name
    twitter_user = Twitter.user(twitter_username)

    self.twitter_location = twitter_user.location
    self.twitter_bio = twitter_user.description
    self.twitter_image_url = twitter_user.profile_image_url
    self.twitter_joined = twitter_user.created_at
  end

  # Updates the user audience
  def update_audience
    twitter_username = user.twitter_screen_name
    twitter_user = Twitter.user(twitter_username)

    audience = self.audience || self.build_audience
    audience.followers = twitter_user.followers_count
    audience.friends = twitter_user.friends_count
    audience.tweets = twitter_user.statuses_count
    audience.males ||= 0.5

    audience.save
  end

  # Creates the user profiles for payments
  def assign_default_prices
    followers = self.audience.followers

    # Calculates the payment cost depending on the followers
    self.update_attribute(:automatic_tweet_fee, followers * 0.02)
    self.update_attribute(:automatic_cpc_fee, followers * 0.0002)
  end
end