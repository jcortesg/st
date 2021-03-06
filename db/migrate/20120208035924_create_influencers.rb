class CreateInfluencers < ActiveRecord::Migration
  def change
    create_table :influencers do |t|
      t.integer :user_id

      t.string :first_name
      t.string :last_name

      t.string :twitter_location
      t.string :twitter_image_url
      t.string :twitter_bio
      t.datetime :twitter_joined

      t.decimal :borwin_fee, null: false, default: 0.3, precision: 8, scale: 2

      t.string :influencer_type
      t.string :first_name
      t.string :last_name
      t.string :sex, :size => 1
      t.date :birthday
      t.text :description
      t.string :referrer_description

      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at


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

      t.decimal :fixed_tweet_fee, precision: 8, scale: 2
      t.decimal :fixed_cpc_fee, precision: 5, scale: 2
      t.decimal :combined_tweet_fee, precision: 8, scale: 2
      t.decimal :combined_cpc_fee, precision: 5, scale: 2

      t.timestamps
    end
    
    add_index :influencers, :user_id, unique: true
  end
end
