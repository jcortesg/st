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

    if current_user && current_user.twitter_linked?
      # The user is logged in and he already linked his account in the past
      redirect_to root_path, :notice => "Tu cuenta ya esta linkeada a Twitter con el usuario #{current_user.twitter_screen_name}"
    elsif current_user && !current_user.twitter_linked?
      # The user is logged in and he's linked his account
      current_user.twitter_uid = access_token.params['user_id']
      current_user.twitter_screen_name = access_token.params['screen_name']
      current_user.twitter_token = access_token.token
      current_user.twitter_secret = access_token.secret
      current_user.save
      redirect_to home_path_for(current_user)
    else
      # Check if there is any user with that credential, and if there is, redirects the user
      if User.where(twitter_token: access_token.token, twitter_secret: access_token.secret).exists?
        @user = User.where(twitter_token: access_token.token, twitter_secret: access_token.secret).first
        # Login user and redirect
        sign_in(:user, @user)
        redirect_to home_path_for(@user)
      else
        # The credentials doesn't exist, create the account
        @user = User.new
        session['twitter_uid'] = access_token.params['user_id']
        session['twitter_screen_name'] = access_token.params['screen_name']
        session['twitter_token'] = access_token.token
        session['twitter_secret'] = access_token.secret
        redirect_to new_influencer_registration_path
      end
    end
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