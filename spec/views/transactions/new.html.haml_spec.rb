require 'spec_helper'

describe "transactions/new.html.haml" do
  before(:each) do
    assign(:transaction, stub_model(Transaction,
      :tweet_id => 1,
      :payment_type_id => 1,
      :amount => "9.99",
      :borwin_amount => "9.99",
      :avg_cpc => "9.99",
      :dineromail_id => 1,
      :payment_method_id => 1,
      :currency_id => 1,
      :holder => "MyString",
      :number => "MyString",
      :bank => "MyString"
    ).as_new_record)
  end

  it "renders new transaction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => transactions_path, :method => "post" do
      assert_select "input#transaction_tweet_id", :name => "transaction[tweet_id]"
      assert_select "input#transaction_payment_type_id", :name => "transaction[payment_type_id]"
      assert_select "input#transaction_amount", :name => "transaction[amount]"
      assert_select "input#transaction_borwin_amount", :name => "transaction[borwin_amount]"
      assert_select "input#transaction_avg_cpc", :name => "transaction[avg_cpc]"
      assert_select "input#transaction_dineromail_id", :name => "transaction[dineromail_id]"
      assert_select "input#transaction_payment_method_id", :name => "transaction[payment_method_id]"
      assert_select "input#transaction_currency_id", :name => "transaction[currency_id]"
      assert_select "input#transaction_holder", :name => "transaction[holder]"
      assert_select "input#transaction_number", :name => "transaction[number]"
      assert_select "input#transaction_bank", :name => "transaction[bank]"
    end
  end
end
