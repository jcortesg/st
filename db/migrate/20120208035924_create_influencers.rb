class CreateInfluencers < ActiveRecord::Migration
  def change
    create_table :influencers do |t|
      t.integer :user_id
      t.string :twitter_username
      t.string :influencer_type
      t.decimal :borwin_fee, :default => 0.3, :precision => 8, :scale => 2
      t.string :location
      t.date :joined_twitter
      t.string :image_url
      t.string :bio
      t.string :description
      t.string :contact_method
      t.string :firstname
      t.string :lastname
      t.text :sex
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :zip_code
      t.string :phone
      t.string :cell_phone
      t.string :contact_time
      t.string :account_number
      t.string :account_type
      t.string :cbu
      t.string :bank_name
    end
    
    add_index :influencers, :user_id, :unique => true       
    add_index :influencers, :twitter_username, :unique => true    
  end
end
