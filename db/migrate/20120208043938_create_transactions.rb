class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :tweet_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.decimal :borwin_amount, :precision => 8, :scale => 2
      
      t.integer :currency_id
      
      t.integer :dineromail_id      
      t.integer :payment_method_id
      t.string :holder
      t.string :number
      t.date :expiration
      t.string :bank
      t.datetime :payment_date  
      
      t.boolean :influencer_paid
      t.datetime :influencer_paid_date
      
      t.timestamps
    end
    
    add_index :transactions, :tweet_id, :unique => true    
    add_index :transactions, :dineromail_id, :unique => true 
  end
end
