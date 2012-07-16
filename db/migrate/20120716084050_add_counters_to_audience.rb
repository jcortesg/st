class AddCountersToAudience < ActiveRecord::Migration
  def change
    add_column :audiences, :males_count, :integer, null: false, default: 0
    add_column :audiences, :females_count, :integer, null: false, default: 0
    add_column :audiences, :moms_count, :integer, null: false, default: 0
    add_column :audiences, :teens_count, :integer, null: false, default: 0
    add_column :audiences, :college_students_count, :integer, null: false, default: 0
    add_column :audiences, :young_women_count, :integer, null: false, default: 0
    add_column :audiences, :young_men_count, :integer, null: false, default: 0
    add_column :audiences, :adult_women_count, :integer, null: false, default: 0
    add_column :audiences, :adult_men_count, :integer, null: false, default: 0
    add_column :audiences, :sports_count, :integer, null: false, default: 0
    add_column :audiences, :fashion_count, :integer, null: false, default: 0
    add_column :audiences, :music_count, :integer, null: false, default: 0
    add_column :audiences, :movies_count, :integer, null: false, default: 0
    add_column :audiences, :politics_count, :integer, null: false, default: 0
    add_column :audiences, :technology_count, :integer, null: false, default: 0
    add_column :audiences, :travel_count, :integer, null: false, default: 0
    add_column :audiences, :luxury_count, :integer, null: false, default: 0
  end
end
