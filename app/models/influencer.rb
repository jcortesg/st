class Influencer < ActiveRecord::Base
  has_one :profile
  has_one :audience
  has_many :top_followers
  has_many :tweets
  belongs_to :user

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :influencer_type, :presence => true

  before_create :update_twitter_data, :assign_default_prices
  after_create :update_audience

  attr_accessible :first_name, :last_name, :location, :image_url, :bio, :influencer_type, :sex, :description,
                  :referrer_description, :address, :city, :state, :country, :zip_code, :phone, :cell_phone,
                  :contact_time, :contact_method, :preferred_payment, :account_number, :account_type, :cbu, :bank_name

  def self.influencers_list_with_current_profile_and_audience(filters)
    followers = filters[:followers]
    friends = filters[:friends]
    retweets = filters[:retweets]
    fee = filters[:fee]
    cpc = filters[:cpc]
    peerindex = filters[:peerindex]
    klout = filters[:klout]
    influencer_type = filters[:influencer] ? filters[:influencer][:type] : nil
    male_percentaje = filters[:male_percentaje]
    male_operation = filters[:male_operation]
    mothers = filters[:mothers]
    sports = filters[:sports]
      
    if followers && followers != ""
      followers = "AND audiences.followers >= #{followers}"
    end
    
    if retweets && retweets != ""
      retweets = retweets.to_f / 100
      retweets = "AND audiences.retweets >= #{retweets}"
    end

    if fee && fee != ""
      fee = "AND profiles.fee <= #{fee}"
    end
    
    if mothers && mothers != ""
      mothers = "AND audiences.moms = 1"
    end
    
    if sports && sports != ""
      sports = "AND audiences.sports = 1"
    end        
    
    if cpc && cpc != ""
      cpc = "AND profiles.cpc <= #{cpc}"
    end
    
    if friends && friends != ""
      friends = "AND audiences.friends >= #{friends}"
    end        

    if influencer_type && influencer_type != ""
      influencer_type = "AND influencers.influencer_type = '#{influencer_type}'"
    end

    if male_percentaje && male_percentaje != ""
      male_percentaje = male_percentaje.to_f / 100
      male_percentaje = "AND audiences.males #{male_operation} #{male_percentaje}"    
    end

    if peerindex && peerindex != ""
      peerindex = "AND audiences.peerindex >= #{peerindex}"
    end
    
    if klout && klout != ""
      klout = "AND audiences.klout >= #{klout}"
    end    
    
    @influencers = Influencer.select("influencers.id, influencers.image_url, influencers.twitter_username, influencers.firstname,
      influencers.lastname, influencers.influencer_type, influencers.bio, profiles.fee, profiles.cpc, profiles.fee_cpc, profiles.cpc_fee, 
        audiences.followers").joins(:current_audience, :current_profile, :user).where("users.approved = 1 #{followers} #{friends} #{influencer_type}
          #{male_percentaje} #{peerindex} #{klout} #{fee} #{cpc} #{retweets} #{mothers} #{sports}")  
  end
      
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

  # Creates the user profile for payments
  def assign_default_prices
    followers = self.audience.followers

    # Calculates the payment cost depending on the followers
    self.fee = followers * 0.25
    self.cpc = 5
    self.fee_cpc = followers * 0.25 / 2.5
    self.cpc_fee = 3
  end
end