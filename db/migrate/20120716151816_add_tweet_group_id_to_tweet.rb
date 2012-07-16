class AddTweetGroupIdToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_group_id, :integer, after: 'influencer_id'
  end
end
