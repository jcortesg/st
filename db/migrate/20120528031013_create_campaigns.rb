class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :advertiser

      t.string :name

      t.boolean :archived, null: false, default: false

      t.integer :min_followers, null: false, default: 0
      t.integer :max_followers, null: false, default: 2000000

      t.integer :min_males, null: false, default: 0
      t.integer :max_males, null: false, default: 100
      t.integer :min_females, null: false, default: 0
      t.integer :max_females, null: false, default: 100

      t.integer :min_kids, null: false, default: 0
      t.integer :max_kids, null: false, default: 100
      t.integer :min_adults, null: false, default: 0
      t.integer :max_adults, null: false, default: 100
      t.integer :min_elderly, null: false, default: 0
      t.integer :max_elderly, null: false, default: 100

      t.integer :min_young_teens, null: false, default: 0
      t.integer :max_young_teens, null: false, default: 100
      t.integer :min_mature_teens, null: false, default: 0
      t.integer :max_mature_teens, null: false, default: 100
      t.integer :min_young_adults, null: false, default: 0
      t.integer :max_young_adults, null: false, default: 100
      t.integer :min_mature_adults, null: false, default: 0
      t.integer :max_mature_adults, null: false, default: 100

      t.integer :min_sports, null: false, default: 0
      t.integer :max_sports, null: false, default: 100
      t.integer :min_fashion, null: false, default: 0
      t.integer :max_fashion, null: false, default: 100
      t.integer :min_music, null: false, default: 0
      t.integer :max_music, null: false, default: 100
      t.integer :min_movies, null: false, default: 0
      t.integer :max_movies, null: false, default: 100
      t.integer :min_politics, null: false, default: 0
      t.integer :max_politics, null: false, default: 100

      t.integer :clicks, null: false, default: 0
      t.decimal :cost, precision: 8, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :campaigns, :advertiser_id
    add_index :campaigns, :archived
  end
end
