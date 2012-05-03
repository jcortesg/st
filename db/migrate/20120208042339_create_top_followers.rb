class CreateTopFollowers < ActiveRecord::Migration
  def change
    create_table :top_followers do |t|
      t.integer :influencer_id
      t.string :twitter_username
      t.integer :followers
      t.integer :followers_followers
      t.integer :clicks
      t.integer :retweets

      t.timestamps
    end

    add_index :top_followers, :influencer_id, :unique => false        
  end
end
