class CreateAudiences < ActiveRecord::Migration
  def change
    create_table :audiences do |t|
      t.integer :influencer_id

      # Twitter data
      t.integer :followers, default: 0, null: false
      t.integer :followers_followers, default: 0, null: false
      t.integer :friends, default: 0, null: false
      t.integer :tweets, default: 0, null: false
      t.decimal :retweets, precision: 3, scale: 2, default: 0, null: false

      # Twitter indexes
      t.integer :peerindex, default: 0, null: false
      t.integer :klout, default: 0, null: false

      # Percent values
      t.decimal :males, precision: 3, scale: 2, default: 0, null: false
      t.decimal :moms, precision: 3, scale: 2, default: 0, null: false
      t.decimal :kids, precision: 3, scale: 2, default: 0, null: false
      t.decimal :young_teens, precision: 3, scale: 2, default: 0, null: false
      t.decimal :mature_teens, precision: 3, scale: 2, default: 0, null: false
      t.decimal :young_adults, precision: 3, scale: 2, default: 0, null: false
      t.decimal :mature_adults, precision: 3, scale: 2, default: 0, null: false
      t.decimal :adults, precision: 3, scale: 2, default: 0, null: false
      t.decimal :elderly, precision: 3, scale: 2, default: 0, null: false

      # Boolean values
      t.boolean :sports, default: false, null: false
      t.boolean :fashion, default: false, null: false
      t.boolean :music, default: false, null: false
      t.boolean :movies, default: false, null: false
      t.boolean :politics, default: false, null: false
      t.string :status, lenght: 1, default: "A"

      t.timestamps
    end
    
    add_index :audiences, :influencer_id, unique: false
  end
end
