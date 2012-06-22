class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :screen_name

      t.references :twitter_country
      t.references :twitter_state

      t.boolean :gender_male
      t.boolean :gender_female

      t.boolean :sports
      t.boolean :fashion
      t.boolean :music
      t.boolean :movies
      t.boolean :politics
      t.boolean :technology
      t.boolean :travel
      t.boolean :luxury

      t.timestamps
    end

    add_index :twitter_users, :screen_name, unique: true
  end
end
