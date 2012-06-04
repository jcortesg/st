class CreateAudiences < ActiveRecord::Migration
  def change
    create_table :audiences do |t|
      t.integer :influencer_id

      # Twitter data
      t.integer :followers, default: 0, null: false
      t.integer :friends, default: 0, null: false
      t.integer :tweets, default: 0, null: false
      t.integer :retweets, default: 0, null: false

      # Twitter indexes
      t.integer :peerindex, default: 0, null: false
      t.integer :klout, default: 0, null: false

      # Percent values
      t.integer :males, default: 0, null: false
      t.integer :females, default: 0, null: false
      t.integer :moms, default: 0, null: false
      t.integer :teens, default: 0, null: false
      t.integer :college_students, default: 0, null: false
      t.integer :young_women, default: 0, null: false
      t.integer :young_men, default: 0, null: false
      t.integer :adult_women, default: 0, null: false
      t.integer :adult_men, default: 0, null: false

      t.integer :sports, default: 0, null: false
      t.integer :fashion, default: 0, null: false
      t.integer :music, default: 0, null: false
      t.integer :movies, default: 0, null: false
      t.integer :politics, default: 0, null: false

      t.timestamps
    end
    
    add_index :audiences, :influencer_id, unique: false
  end
end
