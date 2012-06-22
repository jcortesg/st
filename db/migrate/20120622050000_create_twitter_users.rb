class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :twitter_uid
      t.string :twitter_screen_name
      t.string :name
      t.string :location
      t.string :profile_image_url
      t.integer :followers
      t.integer :friends
      t.integer :tweets

      t.references :twitter_country
      t.references :twitter_state

      t.boolean :gender_male, default: false, null: false
      t.boolean :gender_female, default: false, null: false

      t.boolean :sports, default: false, null: false
      t.boolean :fashion, default: false, null: false
      t.boolean :music, default: false, null: false
      t.boolean :movies, default: false, null: false
      t.boolean :politics, default: false, null: false
      t.boolean :technology, default: false, null: false
      t.boolean :travel, default: false, null: false
      t.boolean :luxury, default: false, null: false

      t.timestamps
    end

    add_index :twitter_users, :twitter_uid, unique: true
  end
end
