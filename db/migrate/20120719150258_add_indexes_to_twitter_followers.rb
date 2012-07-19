class AddIndexesToTwitterFollowers < ActiveRecord::Migration
  def change
    add_index :twitter_followers, [:influencer_id]
    add_index :twitter_followers, [:twitter_user_id]

    add_index :twitter_users, [:twitter_uid]
  end
end
