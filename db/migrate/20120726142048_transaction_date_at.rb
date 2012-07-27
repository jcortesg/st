class TransactionDateAt < ActiveRecord::Migration
  def up
    change_column :transactions, :transaction_on, :datetime
    rename_column :transactions, :transaction_on, :transaction_at
    add_index :transactions, :transaction_at
  end

  def down
    remove_index :transactions, :transaction_at
    rename_column :transactions, :transaction_at, :transaction_on
    change_column :transactions, :transaction_on
    , :date
  end
end
