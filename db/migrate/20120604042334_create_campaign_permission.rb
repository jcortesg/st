class CreateCampaignPermission < ActiveRecord::Migration
  def up
    add_column :advertisers, :can_create_campaigns, :boolean, null: false, default: false, after: :phone
  end

  def down
    remove_column :advertisers, :can_create_campaigns
  end
end
