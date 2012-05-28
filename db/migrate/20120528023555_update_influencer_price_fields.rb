class UpdateInfluencerPriceFields < ActiveRecord::Migration
  def up
    rename_column :influencers, :fixed_tweet_fee, :tweet_fee
    rename_column :influencers, :fixed_cpc_fee, :cpc_fee

    remove_column :influencers, :combined_tweet_fee
    remove_column :influencers, :combined_cpc_fee
  end

  def down
    rename_column :influencers, :tweet_fee, :fixed_tweet_fee
    rename_column :influencers, :cpc_fee, :fixed_cpc_fee

    add_column :influencers, :combined_tweet_fee, :decimal, precision: 8, scale: 2
    add_column :influencers, :combined_cpc_fee, :decimal, precision: 8, scale: 2
  end
end
