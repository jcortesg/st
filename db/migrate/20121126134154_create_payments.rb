class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.text :description
      t.float :amount
      t.string :status
      t.string :gateway
      t.string :payment_url

      t.timestamps
    end
  end
end
