class Influencer < ActiveRecord::Base
  has_many :profiles
  has_one :current_profile, :class_name => "Profile", :conditions => "profiles.status = 'A'", :order => "created_at DESC"
  has_many :audiences
  has_one :current_audience, :class_name => "Audience", :conditions => "audiences.status = 'A'", :order => "created_at DESC"
  has_many :top_followers
  has_many :tweets
  belongs_to :user
  
  validates :twitter_username, :presence => true, :length => { :within => 3..50 }, :uniqueness => true
  validates :firstname, :presence => true
  validates :lastname, :presence => true

  attr_accessible :twitter_username, :influencer_type, :description, :firstname, :lastname, :sex, :address, :city,
                  :state, :country, :zip_code, :phone, :cell_phone, :contact_time, :contact_time, :account_number,
                  :account_type, :cbu, :bank_name, :contact_method, :location, :bio
  
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
      
  def self.influencer_for_user(user)
    return self.find_by_user_id(user.id)
  end
    
  def full_name
  	return self.lastname + ', ' + self.firstname
  end
end