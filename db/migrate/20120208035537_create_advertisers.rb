class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.integer :user_id

      t.string :first_name
      t.string :last_name

      t.string :twitter_location
      t.string :twitter_image_url
      t.string :twitter_bio

      t.string :company
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :zip_code
      t.string :phone
    end
    
    add_index :advertisers, :user_id, :unique => true
  end
end
