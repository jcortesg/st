class AddReferralFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :referral_id, :integer, after: "approved"
    add_column :users, :referral_on, :date, after: "referral_id"
    add_column :users, :referral_commission, :decimal, precision: 3, scale: 2, default: "0.05", null: false, after: "referral_on"

    add_column :users, :mail_on_referral_singup, :boolean, default: true, null: false, after: "referral_commission"
    add_column :users, :mail_on_referral_profit, :boolean, default: true, null: false, after: "mail_on_referral_singup"

    add_index :users, :referral_id
  end
end
