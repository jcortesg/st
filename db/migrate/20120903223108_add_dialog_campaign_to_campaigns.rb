class AddDialogCampaignToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :dialog_campaign, :boolean, null: false, default: false, after: 'cost'
  end
end
