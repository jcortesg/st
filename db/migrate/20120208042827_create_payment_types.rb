class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.string :description
      t.string :status, :null => false, :size => 1, :default => "A"

      t.timestamps
    end 
    
    add_index :payment_types, :name, :unique => true    
  end
end
