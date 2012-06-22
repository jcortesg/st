class CreateTwitterFollowers < ActiveRecord::Migration
  def change
    create_table :twitter_followers do |t|
      t.references :influencer
      t.references :twitter_user

      t.timestamps
    end
    add_index :twitter_followers, [:influencer_id, :twitter_user_id], unique: true
  end
end
