class AddInfluentialToInfluencer < ActiveRecord::Migration
  def change
    add_column :influencers, :technology_influential, :boolean, null: false, default: false
    add_column :influencers, :travel_influential, :boolean, null: false, default: false
    add_column :influencers, :sports_influential, :boolean, null: false, default: false
    add_column :influencers, :music_influential, :boolean, null: false, default: false
    add_column :influencers, :politics_influential, :boolean, null: false, default: false
    add_column :influencers, :fashion_influential, :boolean, null: false, default: false
    add_column :influencers, :movies_influential, :boolean, null: false, default: false
    add_column :influencers, :luxury_influential, :boolean, null: false, default: false
  end
end
