class AddInfluencerIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :influencer_id, :integer, after: :campaign_id
    add_index :tweets, :influencer_id
  end
end
