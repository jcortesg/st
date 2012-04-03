require 'spec_helper'

describe "audiences/index.html.haml" do
  before(:each) do
    assign(:audiences, [
      stub_model(Audience,
        :influencer_id => 1,
        :followers => 1,
        :followers_followers => 1,
        :males => "9.99",
        :females => "9.99",
        :moms => "9.99",
        :kids => "9.99",
        :young_teens => "9.99",
        :mature_teens => "9.99",
        :young_adults => "9.99",
        :mature_adults => "9.99",
        :adults => "9.99",
        :elderly => "9.99",
        :sports => "9.99",
        :fashion => "9.99",
        :music => "9.99",
        :movies => "9.99",
        :politics => "9.99"
      ),
      stub_model(Audience,
        :influencer_id => 1,
        :followers => 1,
        :followers_followers => 1,
        :males => "9.99",
        :females => "9.99",
        :moms => "9.99",
        :kids => "9.99",
        :young_teens => "9.99",
        :mature_teens => "9.99",
        :young_adults => "9.99",
        :mature_adults => "9.99",
        :adults => "9.99",
        :elderly => "9.99",
        :sports => "9.99",
        :fashion => "9.99",
        :music => "9.99",
        :movies => "9.99",
        :politics => "9.99"
      )
    ])
  end

  it "renders a list of audiences" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
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
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
