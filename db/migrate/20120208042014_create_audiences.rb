class CreateAudiences < ActiveRecord::Migration
  def change
    create_table :audiences do |t|
      t.integer :influencer_id
      t.integer :followers, :default => 0
      t.integer :followers_followers, :default => 0
      t.integer :friends, :default => 0
      t.integer :tweets, :default => 0
      t.decimal :retweets, :precision => 3, :scale => 2
      t.integer :peerindex, :default => 0
      t.integer :klout, :default => 0
      t.decimal :males, :precision => 3, :scale => 2
      t.boolean :moms, :default => 0
      
      t.decimal :kids, :precision => 3, :scale => 2
      t.decimal :young_teens, :precision => 3, :scale => 2
      t.decimal :mature_teens, :precision => 3, :scale => 2
      t.decimal :young_adults, :precision => 3, :scale => 2
      t.decimal :mature_adults, :precision => 3, :scale => 2
      t.decimal :adults, :precision => 3, :scale => 2
      t.decimal :elderly, :precision => 3, :scale => 2
      
      t.boolean :sports, :default => 0
      t.boolean :fashion, :default => 0
      t.boolean :music, :default => 0
      t.boolean :movies, :default => 0
      t.boolean :politics, :default => 0
      t.string :status, :lenght => 1, :default => "A"

      t.timestamps
    end
    
    add_index :audiences, :influencer_id, :unique => false    
  end
end
