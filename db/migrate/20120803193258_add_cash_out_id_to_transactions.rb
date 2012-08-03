class AddCashOutIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :cash_out_id, :integer
    add_index :transactions, :cash_out_id
  end
end
