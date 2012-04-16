class Tweet < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :influencer
  belongs_to :advertiser
  belongs_to :payment_type
  has_many :transactions
  has_many :tweet_details
  
  scope :waiting_publication_and_expired, :conditions => "status = 'F' AND date_required <= now()"

  attr_accessible :tweet, :comments, :url, :payment_type_id, :influencer_id, :advertiser_id, :date_posted,
                  :date_required, :campaign_id
      
  def full_status
  	if self.status == "Z"
  	  "Publicado"    
    elsif self.status == "P"
  	  "Publicado"
  	elsif self.status == "F"
  	  "Finalizado"
  	elsif self.status == "A"
  	  "Aprobado por Celebridad"  	  
  	elsif self.status == "R"
  	  "Rechazado por Celebridad"
  	elsif self.status == "I"
  	  "Rechazado por Anunciante"  	  
  	elsif status == "X"
  	  "Pendiente"
  	end
  end  
  
  def profile_for_tweet(payment_name, influencer_id, created_at)
    if payment_name == "fee"
      @profile = Profile.select("fee AS amount, 0 AS amount_alt").where("influencer_id = #{influencer_id} AND created_at <= '#{created_at}'").order("created_at desc").first
    elsif payment_name == "cpc"
      @profile = Profile.select("cpc AS amount, 0 AS amount_alt").where("influencer_id = #{influencer_id} AND created_at <= '#{created_at}'").order("created_at desc").first  
    else
      @profile = Profile.select("fee_cpc AS amount, cpc_fee AS amount_alt").where("influencer_id = #{influencer_id} AND created_at <= '#{created_at}'").order("created_at desc").first    
    end
    
    return @profile
  end
  
  def self.tweets_waiting_conclution_and_expired
    self.select("tweets.*, payment_types.*").joins(:payment_type).where("tweets.status = 'P' AND tweets.date_posted <= now() - 3")
  end
    
  def self.tweets_for_user_with_filters(user, filters)
    status = filters[:status]
    payment_type = filters[:payment_type]

    if status
      status = status.map{|s| "'"+ s + "'"}.join(",")
      status = "AND tweets.status IN (#{status})"
    end

    if payment_type
      payment_type = payment_type.map{|s| "'"+ s + "'"}.join(",")
      payment_type = "AND payment_types.name IN (#{payment_type})"
    end
                
    if user.advertiser?
      @advertiser_id = Advertiser.advertiser_for_user(user).id
      @tweets = Tweet.select("tweets.id, tweets.tweet, tweets.comments, tweets.date_posted, tweets.date_required, tweets.status, tweets.created_at,
        tweets.influencer_id, influencers.twitter_username, payment_types.description, payment_types.name AS payment_name, campaigns.name AS campaign_name, 
          campaigns.id AS campaign_id").joins(:influencer, :payment_type, "LEFT JOIN `campaigns` ON `campaigns`.`id` = `tweets`.`campaign_id`").
            where("tweets.advertiser_id = #{@advertiser_id} #{status} #{payment_type}").order("created_at DESC")  
    elsif user.influencer?
      @influencer_id = Influencer.influencer_for_user(user).id
      @tweets = Tweet.select("tweets.id, tweets.tweet, tweets.comments, tweets.date_posted, tweets.date_required, tweets.status, tweets.created_at,
        tweets.influencer_id, advertisers.brand, payment_types.description, payment_types.name AS payment_name").joins(:advertiser, :payment_type).
          where("tweets.influencer_id = #{@influencer_id} #{status} #{payment_type}").order("created_at DESC")
    end
  end
end