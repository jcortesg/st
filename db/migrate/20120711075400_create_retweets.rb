class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.references :tweet

      t.string   :twitter_id
      t.string   :twitter_screen_name
      t.datetime :twitter_created_at
      t.integer  :twitter_retweet_count
      t.integer  :twitter_friends_count
      t.integer  :twitter_followers_count
      t.string   :twitter_image_url

      t.timestamps
    end
  end
end
