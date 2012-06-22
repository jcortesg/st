class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :attachable, polymorphic: true
      t.references :user

      t.date :transaction_on, null: false

      t.string :transaction_type, null: false
      t.text :details

      t.boolean :borwin_transaction, null: false, default: false

      t.decimal :amount, default: 0, precision: 8, scale: 2, null: false, default: 0
      t.decimal :balance, default: 0, precision: 8, scale: 2, null: false, default: 0

      t.timestamps
    end

    add_index :transactions, :user_id
  end
end
