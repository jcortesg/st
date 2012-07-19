class AddPriceCategoryToInfluencers < ActiveRecord::Migration
  def change
    add_column :price_category, :influencers, :integer, null: false, default: 3
  end
end
