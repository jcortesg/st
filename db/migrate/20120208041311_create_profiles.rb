class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :influencer_id
      t.decimal :fee, :precision => 8, :scale => 2
      t.decimal :cpc, :precision => 5, :scale => 2
      t.decimal :fee_cpc, :precision => 8, :scale => 2
      t.decimal :cpc_fee, :precision => 5, :scale => 2
      t.string :status, :lenght => 1, :default => "A"

      t.timestamps
    end
    
    add_index :profiles, :influencer_id, :unique => false        
  end
end
