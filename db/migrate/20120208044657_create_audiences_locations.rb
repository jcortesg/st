class CreateAudiencesLocations < ActiveRecord::Migration
  def change
    create_table :audiences_locations do |t|
      t.integer :audience_id
      t.integer :location_id
      t.decimal :percentage, :precision => 3, :scale => 2

      t.timestamps
    end
    
    add_index :audiences_locations, :audience_id, :unique => false        
  end
end
