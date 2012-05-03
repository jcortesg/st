class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.string :description
      t.string :status, :lenght => 1, :default => "A"

      t.timestamps
    end
    
    add_index :payment_methods, :name, :unique => true    
  end
end
