class CreateAffiliates < ActiveRecord::Migration
  def change
    create_table :affiliates do |t|
      t.integer :user_id

      t.string :first_name
      t.string :last_name

      t.string :company
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.integer :zip_code
      t.string :phone
    end
    
    add_index :affiliates, :user_id, :unique => true
  end
end
