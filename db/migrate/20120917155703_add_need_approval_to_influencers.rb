class AddNeedApprovalToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :need_approval, :boolean, null: false, default: false
    add_column :influencers, :approved, :boolean, null: false, default: true
    add_column :influencers, :approval_message, :text, null: true
  end
end
