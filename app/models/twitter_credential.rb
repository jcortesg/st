class TwitterCredential < ActiveRecord::Base
  belongs_to :user

  # Saves the twitter credentials, but its not used anymore
  def self.save_credentials(access_token, user_id)      
    @credentials = TwitterCredential.new
    @credentials.user_id = user_id
    @credentials.oauth_token = access_token.token
    @credentials.oauth_secret = access_token.secret
    
    @credentials.save
  end
  
  def self.save_twitter_info(user_id, role)
    if role == "affiliate" 
      return  
    elsif role == "influencer"
    	@entity = Influencer.find_by_user_id(user_id)
    
      self.calculate_audience(@entity.id)    	
    	self.calculate_profile(@entity.id)    	
    elsif role == "advertiser"
    	@entity = Advertiser.find_by_user_id(user_id)
    end

    @twitter_user = Twitter.user(@entity.twitter_username)

    @entity.joined_twitter = @twitter_user.created_at
    @entity.image_url = @twitter_user.profile_image_url
    @entity.location = @twitter_user.location
    
    if role == "influencer"
      @entity.bio = @twitter_user.description
    end
    
    @entity.save
  end
  
  def self.calculate_audience(influencer_id)
    @twitter_username = Influencer.find_by_id(influencer_id).twitter_username
    @twitter_user = Twitter.user(@twitter_username)
    
    logger.info @twitter_user
    
  	Audience.update_all "status = 'F'", "influencer_id = #{influencer_id}"
  	
  	@audience = Audience.new
  	@audience.influencer_id = influencer_id
  	@audience.followers = @twitter_user.followers_count
  	@audience.friends = @twitter_user.friends_count
  	@audience.tweets = @twitter_user.statuses_count
  	@audience.males = 0.5
  	
  	@audience.save
  end
  
  def self.calculate_profile(influencer_id)
    Profile.update_all "status = 'F'", "influencer_id = #{influencer_id}"
    
    followers = Audience.find_by_influencer_id_and_status(influencer_id, 'A').followers
        	
    # calcular differente montos para cada celebrity dependiendo de differentes factores
  	@profile = Profile.new
  	@profile.influencer_id = influencer_id
  	@profile.fee = followers * 0.25
  	@profile.cpc = 5
  	@profile.fee_cpc = followers * 0.25 / 2.5
  	@profile.cpc_fee = 3     
  	
  	@profile.save
  end
end