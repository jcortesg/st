class AddPriceCategoryToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :price_category, :integer, null: false, default: 2
  end
end
