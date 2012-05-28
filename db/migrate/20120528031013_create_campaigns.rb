class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :advertiser

      t.string :name

      t.boolean :archived, null: false, default: false

      t.integer :min_followers
      t.integer :max_followers

      t.integer :min_males
      t.integer :max_males
      t.integer :min_females
      t.integer :max_females

      t.integer :min_kids
      t.integer :max_kids
      t.integer :min_adults
      t.integer :max_adults
      t.integer :min_elderly
      t.integer :max_elderly

      t.integer :min_young_teens
      t.integer :max_young_teens
      t.integer :min_mature_teens
      t.integer :max_mature_teens
      t.integer :min_young_adults
      t.integer :max_young_adults
      t.integer :min_mature_adults
      t.integer :max_mature_adults

      t.integer :min_sports
      t.integer :max_sports
      t.integer :min_fashion
      t.integer :max_fashion
      t.integer :min_music
      t.integer :max_music
      t.integer :min_movies
      t.integer :max_movies
      t.integer :min_politics
      t.integer :max_politics

      t.integer :clicks, null: false, default: 0
      t.decimal :cost, precision: 8, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :campaigns, :advertiser_id
    add_index :campaigns, :archived
  end
end
