class AddTimeToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_at, :datetime, after: :text
    add_index :tweets, :tweet_at
  end
end
