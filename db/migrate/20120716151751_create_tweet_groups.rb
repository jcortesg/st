class CreateTweetGroups < ActiveRecord::Migration
  def change
    create_table :tweet_groups do |t|
      t.references :campaign
      t.references :influencer

      t.timestamps
    end
  end
end
