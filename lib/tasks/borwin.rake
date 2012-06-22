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
end