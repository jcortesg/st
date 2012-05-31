class AddPriceOverrideToInfluencers < ActiveRecord::Migration
  def change
    rename_column :influencers, :tweet_fee, :automatic_tweet_fee
    rename_column :influencers, :cpc_fee, :automatic_cpc_fee
    add_column :influencers, :manual_tweet_fee, :decimal, precision: 8, scale: 2, after: :automatic_cpc_fee
    add_column :influencers, :manual_cpc_fee, :decimal, precision: 8, scale: 2, after: :manual_tweet_fee
  end
end
