class CreateAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      t.integer :user_id

      t.string :first_name
      t.string :last_name

      t.string :location
      t.string :image_url
      t.string :bio

      t.string :company
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :zip_code
      t.string :phone
    end
    
    add_index :advertisers, :user_id, :unique => true    
    add_index :advertisers, :twitter_username, :unique => true
  end
end
