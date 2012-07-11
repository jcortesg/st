class CreateCampaignMetrics < ActiveRecord::Migration
  def change
    create_table :campaign_metrics do |t|
      t.references :campaign

      t.date :metric_on
      t.integer :clicks, default: 0, null: false
      t.integer :retweets, default: 0, null: false
      t.integer :mentions, default: 0, null: false
      t.integer :hashtags, default: 0, null: false
      t.integer :followers, default: 0, null: false

      t.timestamps
    end
  end
end
