# encoding: utf-8
class Influencer < ActiveRecord::Base
  belongs_to :user
  has_one :audience, dependent: :destroy
  has_one :week_map, dependent: :destroy
  has_many :tweet_groups, dependent: :destroy
  has_many :tweets
  has_many :twitter_followers
  has_many :twitter_users, through: :twitter_followers

  has_attached_file :photo, :styles => { :profile => "140x200#", :small => "100x100>", :thumb => "48x48#"  }

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :influencer_type, :presence => true
  validates :price_category, inclusion: { in: 1..5}

  before_create :update_twitter_data
  after_create :update_audience, :assign_default_prices
  before_update :update_campaign_price

  attr_accessible :first_name, :last_name, :location, :image_url, :bio, :influencer_type, :birthday, :photo, :sex,
                  :description, :referrer_description, :address, :city, :state, :country, :zip_code, :phone,
                  :cell_phone, :contact_time, :contact_method, :preferred_payment, :account_number, :account_type, :cbu,
                  :bank_name, :manual_tweet_fee, :manual_cpc_fee, :automatic_tweet_fee, :automatic_cpc_fee,
                  :twitter_users, :borwin_fee, :campaign_fee, :price_category, :luxury_influential, :travel_influential,
                  :fashion_influential, :movies_influential, :sports_influential, :politics_influential,  :technology_influential,
                  :music_influential, :moms_influential, :teens_influential, :college_influential,
                  :young_men_influential, :young_women_influential, :adult_men_influential, :adult_women_influential,
                  :week_map, :best_time

  attr_accessor :clicks_count


  class << self
    def influencer_types
      ["Actor", "Actriz", "Músico", "Deportista", "Conductor", "Periodista", "Modelo", "Mediático", "Artista", "Panelista", "Cheff", "Humorista", "Moda", "Twitteros", "Otros"]
    end

    # Apply the filters
    def apply_filters(campaign)
      influencers = joins(:audience)

      # Apply age filter
      #influencers = influencers.where("audiences.moms > 0") if campaign.moms
      #influencers = influencers.where("audiences.teens > 0") if campaign.teens
      #influencers = influencers.where("audiences.college_students > 0") if campaign.college_students
      #influencers = influencers.where("audiences.young_women > 0") if campaign.young_women
      #influencers = influencers.where("audiences.young_men > 0") if campaign.young_men
      #influencers = influencers.where("audiences.adult_women > 0") if campaign.adult_women
      #influencers = influencers.where("audiences.adult_men > 0") if campaign.adult_men

      # Apply gender filter
      #influencers = influencers.where("audiences.males > 0") if campaign.males
      #influencers = influencers.where("audiences.females > 0") if campaign.females

      # Apply hobbies
      #influencers = influencers.where("audiences.sports > 0") if campaign.sports
      #influencers = influencers.where("audiences.fashion > 0") if campaign.fashion
      #influencers = influencers.where("audiences.music > 0") if campaign.music
      #influencers = influencers.where("audiences.movies > 0") if campaign.movies
      #influencers = influencers.where("audiences.politics > 0") if campaign.politics
      #influencers = influencers.where("audiences.technology > 0") if campaign.technology
      #influencers = influencers.where("audiences.travel > 0") if campaign.travel
      #influencers = influencers.where("audiences.luxury > 0") if campaign.luxury

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
              conditions << "(influencers.campaign_fee >= 0 and influencers.campaign_fee <= 300)"
            when '300-1000'
              conditions << "(influencers.campaign_fee >= 300 and influencers.campaign_fee <= 1000)"
            when '1000-2000'
              conditions << "(influencers.campaign_fee >= 1000 and influencers.campaign_fee <= 2000)"
            when '2000-3000'
              conditions << "(influencers.campaign_fee >= 2000 and influencers.campaign_fee <= 3000)"
            when '3000-5000'
              conditions << "(influencers.campaign_fee >= 3000 and influencers.campaign_fee <= 5000)"
            when '5000-7000'
              conditions << "(influencers.campaign_fee >= 5000 and influencers.campaign_fee <= 7000)"
            when '7000-10000'
              conditions << "(influencers.campaign_fee >= 7000 and influencers.campaign_fee <= 10000)"
            when '10000-20000'
              conditions << "(influencers.campaign_fee >= 10000 and influencers.campaign_fee <= 20000)"
            when '20000-50000'
              conditions << "(influencers.campaign_fee >= 20000 and influencers.campaign_fee <= 50000)"
          end
        end
        influencers = influencers.where(conditions.join(" or "))
      end

      # Before the sort options, we have all the columns
      influencers.select('influencers.*, audiences.*')
    end

    # Applies the default sort
    def apply_default_sort(campaign, influencers)
      # Sort option by influencers' influential
      if ((campaign.sports ? 1 : 0 )+ (campaign.travel ? 1 : 0 ) +
          (campaign.luxury ? 1 : 0  )+ (campaign.technology ? 1 : 0) +
          (campaign.politics ? 1 : 0  )+ (campaign.fashion ? 1 : 0 ) +
          (campaign.music ? 1 : 0  )+ (campaign.movies ? 1 : 0 )  == 1)
        influencers = influencers.order("sports_influential desc") if campaign.sports
        influencers = influencers.order("travel_influential desc") if campaign.travel
        influencers = influencers.order("technology_influential desc") if campaign.technology
        influencers = influencers.order("politics_influential desc") if campaign.politics
        influencers = influencers.order("fashion_influential desc") if campaign.fashion
        influencers = influencers.order("luxury_influential desc") if campaign.luxury
        influencers = influencers.order("music_influential desc") if campaign.music
        influencers = influencers.order("movies_influential desc") if campaign.movies
      end
      if ((campaign.moms ? 1 : 0  )+ (campaign.teens ? 1 : 0 ) +
          (campaign.college_students ? 1 : 0  )+ (campaign.young_men ? 1 : 0 ) +
          (campaign.young_women ? 1 : 0  )+ (campaign.adult_men ? 1 : 0 ) +
          (campaign.adult_women ? 1 : 0  ) == 1)
        influencers = influencers.order("moms_influential desc") if campaign.moms
        influencers = influencers.order("teens_influential desc") if campaign.teens
        influencers = influencers.order("college_influential desc") if campaign.college_students
        influencers = influencers.order("young_men_influential desc") if campaign.young_men
        influencers = influencers.order("young_women_influential desc") if campaign.young_women
        influencers = influencers.order("adult_men_influential desc") if campaign.adult_men
        influencers = influencers.order("adult_women_influential desc") if campaign.adult_women
      end

      # Sort option for sex
      if campaign.males && !campaign.females
        influencers = influencers.order("males_count desc")
      elsif campaign.females && !campaign.males
        influencers = influencers.order("females_count desc")
      end

      # Sort options for age
      columns = []
      columns << "audiences.moms_count" if campaign.moms
      columns << "audiences.teens_count" if campaign.teens
      columns << "audiences.college_students_count" if campaign.college_students
      columns << "audiences.young_women_count" if campaign.young_women
      columns << "audiences.young_men_count" if campaign.young_men
      columns << "audiences.adult_women_count" if campaign.adult_women
      columns << "audiences.adult_men_count" if campaign.adult_men
      if columns.size > 0
        influencers = influencers.select("(#{columns.join(' + ')}) as sum_age").order('sum_age desc')
      end

      # Sort options for hobbies
      columns = []
      columns << "audiences.sports_count" if campaign.sports
      columns << "audiences.fashion_count" if campaign.fashion
      columns << "audiences.music_count" if campaign.music
      columns << "audiences.movies_count" if campaign.movies
      columns << "audiences.politics_count" if campaign.politics
      columns << "audiences.technology_count" if campaign.technology
      columns << "audiences.travel_count" if campaign.travel
      columns << "audiences.luxury_count" if campaign.luxury
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
    # Calculates the payment cost depending on the followers
    self.price_category ||= 2
    self.update_attribute(:automatic_tweet_fee, get_tweet_price_for_category(self.price_category))
    self.update_attribute(:automatic_cpc_fee, (self.automatic_tweet_fee * 3) * 0.001)
    self.update_attribute(:campaign_fee, self.tweet_fee * 3)
  end

  # Update the campaign price of the campaign after the tweet price is updated
  def update_campaign_price
    if price_category_was != price_category
      # Here update the default prices
      self.automatic_tweet_fee = get_tweet_price_for_category(self.price_category)
      self.automatic_cpc_fee = (self.automatic_tweet_fee * 3) * 0.001
    end

    self.campaign_fee = (self.manual_tweet_fee.nil? ? self.automatic_tweet_fee : self.manual_tweet_fee) * 3
  end

  def get_tweet_price_for_category(price_category)
    followers = self.audience.followers

    case price_category
      when 1
        (followers * 0.025) / 3
      when 2
        (followers * 0.0175) / 3
      when 3
        (followers * 0.0150) / 3
      when 4
        (followers * 0.0125) / 3
      when 5
        (followers * 0.0095) / 3
    end
  end
end