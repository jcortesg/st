class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :description
      t.string :status, :lenght => 1, :default => "A"
    end

    add_index :currencies, :name, :unique => true        
  end
end
