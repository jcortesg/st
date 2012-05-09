class AddContactFieldsToAffiliate < ActiveRecord::Migration
  def change
    add_column :affiliates, :preferred_payment, :string, after: :phone
    add_column :affiliates, :account_number, :string, after: :preferred_payment
    add_column :affiliates, :account_type, :string, after: :account_number
    add_column :affiliates, :cbu, :string, after: :account_type
    add_column :affiliates, :bank_name, :string, after: :account_type
  end
end
