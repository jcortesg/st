require 'spec_helper'

describe "tweets/index.html.haml" do
  before(:each) do
    assign(:tweets, [
      stub_model(Tweet,
        :tweet => "Tweet",
        :comments => "Comments",
        :url => "Url",
        :influencer_id => 1,
        :advertiser_id => 1,
        :influencer_approved => false,
        :advertiser_approved => false,
        :campaign_id => 1,
        :status => "MyText"
      ),
      stub_model(Tweet,
        :tweet => "Tweet",
        :comments => "Comments",
        :url => "Url",
        :influencer_id => 1,
        :advertiser_id => 1,
        :influencer_approved => false,
        :advertiser_approved => false,
        :campaign_id => 1,
        :status => "MyText"
      )
    ])
  end

  it "renders a list of tweets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Tweet".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Comments".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
