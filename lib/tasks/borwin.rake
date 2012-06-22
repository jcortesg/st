# encoding: utf-8
namespace :borwin do
  desc 'Updates the influencers twitter data'
  task update_influencer_twitter_data: :environment do
    Influencer.all.each do |influencer|
      next unless influencer.user.twitter_linked?
      influencer.update_audience
    end
    puts "#{Influencer.count} influencer accounts updated"
  end

  desc 'Publish active tweets'
  task public_active_tweets: :environment do
    tweets = Tweet.where("status = 'accepted' and tweet_at > ? and tweet_at < ?", Time.now - 5.minutes, Time.now + 5.minutes).all
    tweets.each do |tweet|
      influencer = tweet.influencer
      Twitter.configure do |config|
        config.consumer_key = TWITTER_CONSUMER_KEY
        config.consumer_secret = TWITTER_CONSUMER_SECRET
        config.oauth_token = influencer.user.twitter_token
        config.oauth_token_secret = influencer.user.twitter_secret
      end
      Twitter.update(tweet.text)
      tweet.activate
    end
  end

  desc 'Generate default keywords'
  task generate_default_keywords: :environment do
    ['males', 'females', 'sports', 'fashion', 'music', 'movies', 'politics', 'technology', 'travel', 'luxury'].each do |keyword_name|
        Keyword.create(name: keyword_name) unless Keyword.where(name: keyword_name).exists?
    end
  end

  desc 'Generate the default countries'
  task generate_default_countries: :environment do
    ['Argentina', 'Colombia', 'Chile', 'Ecuador', 'Paraguay', 'Uruguay'].each do |country_name|
      TwitterCountry.create(name: country_name) unless TwitterCountry.where(name: country_name).exists?
    end
  end

  desc 'Generate the default states'
  task genreate_default_states: :environment do
    argentina = TwitterCountry.where(name: 'Argentina').first
    ['Buenos Aires', 'Catamarca', 'Chaco', 'Córdoba', 'Corrientes', 'Entre Ríos', 'Formosa', 'Jujuy', 'La Pampa',
     'La Rioja', 'Mendoza', 'Misiones', 'Neuquén', 'Rio Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz',
     'Santa Fe', 'Sgo. del Estero', 'Tierra del Fuego', 'Tucumán'].each do |state_name|
      TwitterState.create(name: state_name, twitter_country: argentina) unless TwitterState.where(name: state_name).exists?
    end
  end

  desc 'Updates the list of twitter users and followership relations'
  task update_twitter_users: :environment do
    # First we destroy all the twitter follower relationships
    TwitterFollower.delete_all
    # Now we iterate on every influencer, to get who follows him
    #Influencer.joins(:audience).includes(:user).order('audiences.followers desc').all.each do |influencer|
    Influencer.joins(:audience).includes(:user).where(id: 70).order('audiences.followers desc').all.each do |influencer|
      # First we get the list of all the followers
      cursor = "-1"
      follower_ids = []
      while cursor != 0 do
        followers = Twitter.follower_ids(influencer.user.twitter_screen_name, {cursor: cursor})

        cursor = followers.next_cursor
        follower_ids += followers.ids
        sleep(1)
      end

      # Now we create the user if it doesn't exist
      follower_ids.each do |follower_id|
        # Find or create the twitter user
        twitter_user = TwitterUser.where(twitter_uid: follower_id).first || TwitterUser.create(twitter_uid: follower_id)
        twitter_user.influencers << influencer
        twitter_user.save
      end
    end
  end
end