class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :source_id
      t.integer :destination_id
      t.date :since
      t.date :through
      t.decimal :commission, :precision => 3, :scale => 2
    end
    
    add_index :referrals, :source_id, :unique => false           
  end
end
