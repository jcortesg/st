require 'spec_helper'

describe "advertisers/index.html.haml" do
  before(:each) do
    assign(:advertisers, [
      stub_model(Advertiser,
        :user_id => 1,
        :twitter_username => "Twitter Username",
        :borwin_fee => "9.99",
        :brand => "Brand",
        :address => "Address",
        :city => "City",
        :state => "State",
        :country => "Country",
        :zip_code => 1,
        :phone => "Phone"
      ),
      stub_model(Advertiser,
        :user_id => 1,
        :twitter_username => "Twitter Username",
        :borwin_fee => "9.99",
        :brand => "Brand",
        :address => "Address",
        :city => "City",
        :state => "State",
        :country => "Country",
        :zip_code => 1,
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of advertisers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Twitter Username".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Brand".to_s, :count => 2
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
