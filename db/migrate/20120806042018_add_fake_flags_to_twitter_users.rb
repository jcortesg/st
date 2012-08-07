class AddFakeFlagsToTwitterUsers < ActiveRecord::Migration
  def change
    add_column :twitter_users, :invalid_page, :bool, default: false, null: false
    add_column :twitter_users, :private_tweets, :bool, default: false, null: false
    add_index :twitter_users, :invalid_page
    add_index :twitter_users, :private_tweets
  end
end
