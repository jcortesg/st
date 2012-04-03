require 'spec_helper'

describe "transactions/index.html.haml" do
  before(:each) do
    assign(:transactions, [
      stub_model(Transaction,
        :tweet_id => 1,
        :payment_type_id => 1,
        :amount => "9.99",
        :borwin_amount => "9.99",
        :avg_cpc => "9.99",
        :dineromail_id => 1,
        :payment_method_id => 1,
        :currency_id => 1,
        :holder => "Holder",
        :number => "Number",
        :bank => "Bank"
      ),
      stub_model(Transaction,
        :tweet_id => 1,
        :payment_type_id => 1,
        :amount => "9.99",
        :borwin_amount => "9.99",
        :avg_cpc => "9.99",
        :dineromail_id => 1,
        :payment_method_id => 1,
        :currency_id => 1,
        :holder => "Holder",
        :number => "Number",
        :bank => "Bank"
      )
    ])
  end

  it "renders a list of transactions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Holder".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Bank".to_s, :count => 2
  end
end
