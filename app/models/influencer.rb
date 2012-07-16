# encoding: utf-8
class Influencer < ActiveRecord::Base
  belongs_to :user
  has_one :audience, dependent: :destroy
  has_many :tweets
  has_many :twitter_followers
  has_many :twitter_users, through: :twitter_followers

  has_attached_file :photo, :styles => { :profile => "140x200#", :small => "100x100>", :thumb => "48x48#"  }

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :influencer_type, :presence => true

  before_create :update_twitter_data
  after_create :update_audience, :assign_default_prices

  attr_accessible :first_name, :last_name, :location, :image_url, :bio, :influencer_type, :birthday, :photo, :sex,
                  :description, :referrer_description, :address, :city, :state, :country, :zip_code, :phone,
                  :cell_phone, :contact_time, :contact_method, :preferred_payment, :account_number, :account_type, :cbu,
                  :bank_name, :manual_tweet_fee, :manual_cpc_fee, :automatic_tweet_fee, :automatic_cpc_fee,
                  :twitter_users, :borwin_fee

  attr_accessor :clicks_count


  class << self
    def influencer_types
      ["Actor", "Actriz", "Músico", "Deportista", "Conductor", "Periodista", "Modelo", "Mediático", "Artista", "Panelista", "Cheff", "Humorista", "Moda", "Twitteros", "Otros"]
    end

    # Apply the filters
    def apply_filters(campaign)
      influencers = joins(:audience)

      # Apply age filter
      influencers = influencers.where("audiences.moms > 0") if campaign.moms
      influencers = influencers.where("audiences.teens > 0") if campaign.teens
      influencers = influencers.where("audiences.college_students > 0") if campaign.college_students
      influencers = influencers.where("audiences.young_women > 0") if campaign.young_women
      influencers = influencers.where("audiences.young_men > 0") if campaign.young_men
      influencers = influencers.where("audiences.adult_women > 0") if campaign.adult_women
      influencers = influencers.where("audiences.adult_men > 0") if campaign.adult_men

      # Apply gender filter
      influencers = influencers.where("audiences.males > 0") if campaign.males
      influencers = influencers.where("audiences.females > 0") if campaign.females

      # Apply hobbies
      influencers = influencers.where("audiences.sports > 0") if campaign.sports
      influencers = influencers.where("audiences.fashion > 0") if campaign.fashion
      influencers = influencers.where("audiences.music > 0") if campaign.music
      influencers = influencers.where("audiences.movies > 0") if campaign.movies
      influencers = influencers.where("audiences.politics > 0") if campaign.politics
      influencers = influencers.where("audiences.technology > 0") if campaign.technology
      influencers = influencers.where("audiences.travel > 0") if campaign.travel
      influencers = influencers.where("audiences.luxury > 0") if campaign.luxury

      # Apply followers filters
      if campaign.followers_qty.try(:size) > 0
        conditions = ["(1 = 0)"]
        campaign.followers_qty.each do |fq|
          case fq
            when '0-500'
              conditions << "(audiences.followers >= 0 and audiences.followers <= 500)"
            when '500-2000'
              conditions << "(audiences.followers >= 500 and audiences.followers <= 2000)"
            when '2000-10000'
              conditions << "(audiences.followers >= 2000 and audiences.followers <= 10000)"
            when '10000-100000'
              conditions << "(audiences.followers >= 10000 and audiences.followers <= 100000)"
            when '100000-300000'
              conditions << "(audiences.followers >= 100000 and audiences.followers <= 300000)"
            when '300000-600000'
              conditions << "(audiences.followers >= 300000 and audiences.followers <= 600000)"
            when '600000-900000'
              conditions << "(audiences.followers >= 600000 and audiences.followers <= 900000)"
            when '900000-2000000'
              conditions << "(audiences.followers >= 900000 and audiences.followers <= 2000000)"
            when '2000000-50000000'
              conditions << "(audiences.followers >= 2000000 and audiences.followers <= 50000000)"
          end
        end
        influencers = influencers.where(conditions.join(" or "))
      end

      # Apply price filters
      if campaign.tweet_price.try(:size) > 0
        conditions = ["(1 = 0)"]
        campaign.tweet_price.each do |tp|
          case tp
            when '0-300'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 0 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 300)"
            when '300-1000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 300 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 1000)"
            when '1000-2000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 1000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 2000)"
            when '2000-3000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 2000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 3000)"
            when '3000-5000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 3000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 5000)"
            when '5000-7000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 5000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 7000)"
            when '7000-10000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 7000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 10000)"
            when '10000-20000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 10000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 20000)"
            when '20000-50000'
              conditions << "(COALESCE(manual_tweet_fee, automatic_tweet_fee) >= 20000 and COALESCE(manual_tweet_fee, automatic_tweet_fee) <= 50000)"
          end
        end
        influencers = influencers.where(conditions.join(" or "))
      end

      # Before the sort options, we have all the columns
      influencers.select('influencers.*, audiences.*')
    end

    # Applies the default sort
    def apply_default_sort(campaign, influencers)
      # Sort option for sex
      if campaign.males && !campaign.females
        influencers = influencers.order("males desc")
      elsif campaign.females && !campaign.males
        influencers = influencers.order("females desc")
      end

      # Sort options for age
      columns = []
      columns << "audiences.moms" if campaign.moms
      columns << "audiences.teens" if campaign.teens
      columns << "audiences.college_students" if campaign.college_students
      columns << "audiences.young_women" if campaign.young_women
      columns << "audiences.young_men" if campaign.young_men
      columns << "audiences.adult_women" if campaign.adult_women
      columns << "audiences.adult_men" if campaign.adult_men
      if columns.size > 0
        influencers = influencers.select("(#{columns.join(' + ')}) as sum_age").order('sum_age desc')
      end

      # Sort options for hobbies
      columns = []
      columns << "audiences.sports" if campaign.sports
      columns << "audiences.fashion" if campaign.fashion
      columns << "audiences.music" if campaign.music
      columns << "audiences.movies" if campaign.movies
      columns << "audiences.politics" if campaign.politics
      columns << "audiences.technology" if campaign.technology
      columns << "audiences.travel" if campaign.travel
      columns << "audiences.luxury" if campaign.luxury
      if columns.size > 0
        influencers = influencers.select("(#{columns.join(' + ')}) as sum_hobbies").order('sum_hobbies desc')
      end

      influencers.order('audiences.followers desc')
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

  # Influencer CPC price with commission applied
  def influencer_cpc_fee
    cpc_fee - (cpc_fee * borwin_fee)
  end

  # Influencer Tweet price with commission applied
  def influencer_tweet_fee
    tweet_fee - (tweet_fee * borwin_fee)
  end

  # Campaign Tweet price with commission applied
  def influencer_campaign_fee
    self.influencer_tweet_fee * 3
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
    self.update_attribute(:automatic_tweet_fee, (followers * 0.0175) / 3)
    self.update_attribute(:automatic_cpc_fee, self.automatic_tweet_fee * 0.1)
    self.update_attribute(:campaign_fee, self.tweet_fee * 3)
  end
end