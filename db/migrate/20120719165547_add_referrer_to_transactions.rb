class AddReferrerToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :referrer_id, :integer
  end
end
