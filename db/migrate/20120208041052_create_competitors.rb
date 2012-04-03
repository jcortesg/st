class CreateCompetitors < ActiveRecord::Migration
  def change
    create_table :competitors do |t|
      t.integer :advertiser_id
      t.integer :competitor_id
    end
    
    add_index :competitors, :advertiser_id, :unique => false        
  end
end
