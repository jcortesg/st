class UpdatePorcentageFieldForReferrers < ActiveRecord::Migration
  def up
    remove_column :users, :referrer_commission
    add_column :users, :referrer_commission, :int, after: "referrer_on"
  end

  def down
    remove_column :users, :referrer_commission
    add_column :users, :referrer_commission, :decimal, :decimal, precision: 3, scale: 2, default: "0.05", null: false, after: "referrer_on"
  end
end
