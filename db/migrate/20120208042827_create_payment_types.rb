class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.string :description
      t.string :status, :lenght => 1, :default => "A"      
    end 
    
    add_index :payment_types, :name, :unique => true    
  end
end
