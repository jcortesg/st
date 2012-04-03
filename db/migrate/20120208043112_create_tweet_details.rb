class CreateTweetDetails < ActiveRecord::Migration
  def change
    create_table :tweet_details do |t|
      t.integer :tweet_id
      t.integer :clicks
      t.integer :retweets
    end
    
    add_index :tweet_details, :tweet_id, :unique => true    
  end
end
