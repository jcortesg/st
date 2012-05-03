class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.string :tweet
      t.string :comments
      t.string :url
      t.integer :payment_type_id
      t.integer :influencer_id
      t.integer :advertiser_id
      t.datetime :date_posted
      t.datetime :date_required
      t.integer :campaign_id
      t.string :status, :lenght => 1, :default => "X"

      t.timestamps
    end

    add_index :tweets, :influencer_id, :unique => false
    add_index :tweets, :advertiser_id, :unique => false
    add_index :tweets, :campaign_id, :unique => false
  end
end
