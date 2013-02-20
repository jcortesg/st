# encoding: utf-8
class Admin::TweetsController < ApplicationController
  before_filter :find_campaign

  # Shows the tweets
  def index
    @search = Tweet.search(params[:search])
    @tweets = @search.page(params[:page])
  end

  # Shows the details of a tweet
  def show
    @tweet = Tweet.find(params[:id])
  end

  # Shows the form to modify a tweet
  def edit
    @tweet = Tweet.find(params[:id])
  end

  # Shows the form to modify a tweet
  def edit_date
    @tweet = Tweet.find(params[:id])
  end

  # Process the tweet modification
  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update_attributes(params[:tweet])
      flash[:success] = "El Tweet fue modificado"
      redirect_to [:admin, @campaign, @tweet]
    else
      flash.now[:error] = "El Tweet no pudo ser modificado"
      render action: :edit
    end
  end

  # Delete a tweet
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    flash[:success] = "El Tweet fue eliminado del sistema"
    redirect_to [:admin, @tweet]
  end


  # Shows the profile of a influencer
  def influencer_profile
    @influencer = Influencer.find(params[:influencer_id])
    @twitter_user = Twitter.user(@influencer.user.twitter_screen_name)
  end

  # Accepts a twitter proposition
  def accept
    @tweet = Tweet.find(params[:id])
    unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
      flash[:notice] = "El estado actual del tweet no permite su aceptación"
      redirect_to action: index and return
    end
    @tweet.influencer_accept
    flash[:success] = "El Tweet ha sido aceptado"
    redirect_to [:admin, @tweet.campaign, @tweet]
  end

  #Forced publication
  def forced_publication
    tweets = Tweet.where("id = #{params[:id]}").all

    tweets.each do |tweet|
      begin
        influencer = tweet.influencer
        puts "[INFO] Tweet por publicar a @" + influencer.user.twitter_screen_name + " - " + tweet.tweet_at.to_s

        publish = true

        if publish
          Twitter.configure do |config|
            config.consumer_key = TWITTER_CONSUMER_KEY
            config.consumer_secret = TWITTER_CONSUMER_SECRET
            config.oauth_token = influencer.user.twitter_token
            config.oauth_token_secret = influencer.user.twitter_secret
          end
          twitter_tweet = Twitter.update(tweet.text)
          puts twitter_tweet.inspect

          # Update the tweet fields
          if ! twitter_tweet.attrs[:id_str].empty?
            tweet.twitter_id = twitter_tweet.attrs[:id_str]
            tweet.twitter_created_at = twitter_tweet.attrs[:created_at]
            tweet.retweet_count = 0
            tweet.status = 'activated'
            puts "[SUCCESS] Publicado en Twitter. ID: " + twitter_tweet.attrs[:id_str]
            if tweet.save
              puts "[SUCCESS] Guardado con éxito"
            else
              puts "[ERROR] El tweet no pudo ser guardado!"
            end
          else
            puts "[ERROR] El tweet no pudo ser publicado!"
          end
        else
          puts "No publicable. "
        end
      rescue Exception => e
        #Logger.rails.info("ERROR: #{e.message}")
        puts "[ERROR] #{e.message}"
        Notifier.error_publishing(tweet)
      end

      begin
        # Now activates the tweet. Internally activates the campaign if needed
        tweet.activate

        # Activate the campaign if needed
        unless tweet.campaign.status == 'active'
          puts "[INFO] La campaña debe ser activada!"
          if (tweet.campaign.activate_campaign rescue nil).nil?
            puts "[ERROR] Error activando campaña"
          end
        end
        # Update campaign reach and share
        if (tweet.campaign.update_reach_and_share rescue nil).nil?
          puts "[ERROR] No se pudo actualizar el Reach & Share de la campaña"
        end

      rescue Exception => e
        puts "[ERROR] #{e.message}"
      end
    end
    redirect_to [:admin, @tweet.campaign, @tweet]
  end

  # Reject cause form
  def reject
    @tweet = Tweet.find(params[:id])
    @influencers = @tweet.campaign.influencers.uniq{|x| x.id}
    # unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
    #  flash[:notice] = "El estado actual del tweet no permite su rechazo"
    #  redirect_to action: index and return
    # end
  end

  # Rejects a tweet giving a reason
  def reject_cause
    @tweet = Tweet.find(params[:id])
    #unless ['created', 'advertiser_reviewed'].include?(@tweet.status)
    #  flash[:notice] = "El estado actual del tweet no permite su rechazo"
    #  redirect_to action: index and return
    #end
    if @tweet.update_attribute(:reject_cause, params[:tweet][:reject_cause])
      @tweet.influencer_reject
      flash[:success] = "El Tweet fue rechazado y remitido al anunciante"
      redirect_to [:admin, @tweet.campaign]
    else
      flash.now[:error] = "El Tweet no pudo ser rechazado"
      render action: :show
    end
  end

  private

  # Gets the current campaign for the controller
  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
