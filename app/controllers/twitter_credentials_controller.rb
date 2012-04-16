class TwitterCredentialsController < ApplicationController
  before_filter :setup_client


  # Redirects the user to twitter so he can login
  def login
    callback_url = "http://#{request.host}#{":#{request.port}" unless request.port == 80}/twitter_credentials/finalize"
    request_token = @client.request_token(:oauth_callback => callback_url)

    session[:request_secret] = request_token.secret

    redirect_url = request_token.authorize_url
    redirect_url = "http://" + redirect_url unless redirect_url.match(/^http:\/\//)
    redirect_to redirect_url
  end

  # Gets the redirection from twitter
  def finalize
    access_token = @client.authorize(params[:oauth_token], session[:request_secret], :oauth_verifier => params[:oauth_verifier])

    TwitterCredential.save_credentials(access_token, session[:signed_up_user_id])

    TwitterCredential.save_twitter_info(session[:signed_up_user_id], session[:signed_up_role])

    session[:request_secret] = nil
    session[:signed_up_user_id] = nil
    session[:signed_up_role] = nil

    redirect_to root_path, notice: 'El usuario se creo con exito. En cuanto este activado podras logearte al sistema'
  end

  def publish
    @tweets = Tweet.waiting_publication_and_expired

    @tweets.each do |tweet|
      user_id = Influencer.find(tweet.influencer_id).user_id

      @credentials = TwitterCredential.find_by_user_id(user_id)

      oauth_token = @credentials.oauth_token
      oauth_secret = @credentials.oauth_secret

      @client = TwitterOAuth::Client.new(
        :consumer_key => APP_CONFIG[:twitter][:consumer_key],
        :consumer_secret => APP_CONFIG[:twitter][:consumer_secret],
        :token => oauth_token,
        :secret => oauth_secret
      )

      tweet_id = @client.update(tweet.tweet).id

      tweet.tweet_id = tweet_id
      tweet.status = "P"
      tweet.date_posted = Date.current
      tweet.save

      #record brand's # of followers, mentions, retweets to calculate brand lift
    end

    respond_to do |format|
      format.json { head :ok }
    end
  end

  def finalize_tweet
    @tweets = Tweet.tweets_waiting_conclution_and_expired

    @tweets.each do |tweet|
      tweet_stats = Twitter.status(tweet.tweet_id)

      tweet.status = "Z"
      tweet.save

      @tweet_details = TweetDetail.new
      @tweet_details.tweet_id = tweet.id
      @tweet_details.clicks = 10 #get clicks from bit.ly
      @tweet_details.retweets = tweet_stats.attrs["retweet_count"]
      @tweet_details.save

      @profile = Profile.profile_for_influencer_id_and_for_date(tweet.influencer_id, tweet.created_at)

      @transaction = Transaction.new
      @transaction.tweet_id = tweet.id

      if tweet.name == "fee"
        @transaction.amount = @profile.fee
      elsif tweet.name == "cpc"
        @transaction.amount = @profile.cpc * @tweet_details.clicks
      else
        @transaction.amount = @profile.fee_cpc + @profile.cpc_fee * @tweet_details.clicks
      end

      @transaction.borwin_amount = @transaction.amount * @profile.borwin_fee
      @transaction.currency_id = 1 #store currency_id
      @transaction.save
    end

    #record brand's # of followers, mentions, retweets to calculate brand lift
  end

  private

  # Setup the twitter oauth client
  def setup_client
    @client = TwitterOAuth::Client.new(
      :consumer_key => APP_CONFIG[:twitter][:consumer_key],
      :consumer_secret => APP_CONFIG[:twitter][:consumer_secret]
    )
  end
end