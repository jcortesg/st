class AddAgeFieldsToTwitterUsers < ActiveRecord::Migration
  def change
    add_column :twitter_users, :moms, :boolean, default: false, null: false
    add_column :twitter_users, :teens, :boolean, default: false, null: false
    add_column :twitter_users, :college_students, :boolean, default: false, null: false
    add_column :twitter_users, :young_women, :boolean, default: false, null: false
    add_column :twitter_users, :young_men, :boolean, default: false, null: false
    add_column :twitter_users, :adult_women, :boolean, default: false, null: false
    add_column :twitter_users, :adult_men, :boolean, default: false, null: false
  end
end
