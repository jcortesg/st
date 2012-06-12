class Click < ActiveRecord::Base
  belongs_to :tweet

  after_create :update_campaign_tweets

  attr_accessible :tweet, :tweet_id, :remote_ip, :remote_agent

  private

  # Updates the campaign counter
  def update_campaign_tweets
    ActiveRecord::Base.connection.execute("UPDATE campaigns SET clicks_count = clicks_count + 1 WHERE id = #{tweet.campaign_id}")
  end
end
