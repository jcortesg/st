class AddAgeInfluentialToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :moms_influential, :boolean, null: false, default: false
    add_column :influencers, :teens_influential, :boolean, null: false, default: false
    add_column :influencers, :college_influential, :boolean, null: false, default: false
    add_column :influencers, :young_women_influential, :boolean, null: false, default: false
    add_column :influencers, :young_men_influential, :boolean, null: false, default: false
    add_column :influencers, :adult_women_influential, :boolean, null: false, default: false
    add_column :influencers, :adult_men_influential, :boolean, null: false, default: false
  end
end
