class AddPricePerClickToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :price_per_click, :boolean, default: false, null: false, after: 'objective'
  end
end
