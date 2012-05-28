class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.references :influencer

      t.integer :min_followers
      t.integer :max_followers

      t.integer :min_males
      t.integer :max_males
      t.integer :min_females
      t.integer :max_females

      t.integer :min_kids
      t.integer :max_kids
      t.integer :min_adults
      t.integer :max_aduls
      t.integer :min_ederly
      t.integer :max_ederly

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
      t.integer :max_fasion
      t.integer :min_music
      t.integer :max_music
      t.integer :min_movies
      t.integer :max_movies
      t.integer :min_politics
      t.integer :max_politics

      t.timestamps
    end

    add_index :campaigns, :influencer_id
  end
end
