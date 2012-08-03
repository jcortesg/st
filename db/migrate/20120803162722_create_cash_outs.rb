class CreateCashOuts < ActiveRecord::Migration
  def change
    create_table :cash_outs do |t|
      t.references :user
      t.decimal :amount, precision: 8, scale: 2, null: false, default: 0

      t.string :status

      t.datetime :paid_at

      t.timestamps
    end
  end
end
