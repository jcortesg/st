class CreateInfluencers < ActiveRecord::Migration
  def change
    create_table :influencers do |t|
      t.integer :user_id

      t.string :first_name
      t.string :last_name

      t.string :location
      t.string :image_url
      t.string :bio

      t.decimal :borwin_fee, :default => 0.3, :precision => 8, :scale => 2

      t.string :influencer_type
      t.string :first_name
      t.string :last_name
      t.string :sex, :size => 1
      t.text :description
      t.string :referrer_description

      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :zip_code
      t.string :phone
      t.string :cell_phone
      t.string :contact_time
      t.string :contact_method

      t.string :preferred_payment
      t.string :account_number
      t.string :account_type
      t.string :cbu
      t.string :bank_name
    end
    
    add_index :influencers, :user_id, :unique => true
  end
end
