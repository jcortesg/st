class AddReferralFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :referrer_id, :integer, after: "approved"
    add_column :users, :referrer_on, :date, after: "referrer_id"
    add_column :users, :referrer_commission, :decimal, precision: 3, scale: 2, default: "0.05", null: false, after: "referrer_on"

    add_column :users, :mail_on_referral_singup, :boolean, default: true, null: false, after: "referrer_commission"
    add_column :users, :mail_on_referral_profit, :boolean, default: true, null: false, after: "mail_on_referral_singup"

    add_index :users, :referrer_id
  end
end
