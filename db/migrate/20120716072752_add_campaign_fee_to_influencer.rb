class AddCampaignFeeToInfluencer < ActiveRecord::Migration
  def change
    add_column :influencers, :campaign_fee, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
