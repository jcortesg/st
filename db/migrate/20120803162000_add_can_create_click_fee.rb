class AddCanCreateClickFee < ActiveRecord::Migration
  def up
    add_column :advertisers, :can_create_click_fee, :boolean, null: false, default: false, after: 'can_create_campaigns'
  end

  def down
    remove_column :advertisers, :can_create_click_fee
  end
end
