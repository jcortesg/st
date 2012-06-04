class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :advertiser

      t.string :name
      t.text :objective

      t.boolean :archived, null: false, default: false

      t.text :locations

      t.boolean :males
      t.boolean :females
      t.boolean :moms
      t.boolean :teens
      t.boolean :college_students
      t.boolean :young_women
      t.boolean :young_men
      t.boolean :adult_women
      t.boolean :adult_men

      t.boolean :sports
      t.boolean :fashion
      t.boolean :music
      t.boolean :movies
      t.boolean :politics

      t.string :followers_quantity

      t.integer :clicks_count, null: false, default: 0
      t.decimal :cost, precision: 8, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :campaigns, :advertiser_id
    add_index :campaigns, :archived
  end
end
