class AddFieldsToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :twitter_id, :string
    add_column :tweets, :twitter_created_at, :datetime
    add_column :tweets, :retweet_count, :integer, null: false, default: 0
  end
end
