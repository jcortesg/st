class AddInfluencerFeeToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :influencer_tweet_fee, :decimal, precision: 8, scale: 2, null: false, default: 0
    add_column :tweets, :influencer_cpc_fee, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
