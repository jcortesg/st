require 'spec_helper'

describe "affiliates/index.html.haml" do
  before(:each) do
    assign(:affiliates, [
      stub_model(Affiliate,
        :user_id => 1,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :address => "Address",
        :city => "City",
        :state => "State",
        :country => "Country",
        :zip_code => 1,
        :phone => "Phone"
      ),
      stub_model(Affiliate,
        :user_id => 1,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :address => "Address",
        :city => "City",
        :state => "State",
        :country => "Country",
        :zip_code => 1,
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of affiliates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
