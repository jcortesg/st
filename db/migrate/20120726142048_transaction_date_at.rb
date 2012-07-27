class TransactionDateAt < ActiveRecord::Migration
  def up
    remove_column :transactions, :transaction_on
    add_index :transactions, :created_at
  end

  def down
    remove_index :transactions, :created_at
    add_column :transactions, :transaction_on, :date, after: 'user_id'
  end
end
