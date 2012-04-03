require 'spec_helper'

describe "tweets/show.html.haml" do
  before(:each) do
    @tweet = assign(:tweet, stub_model(Tweet,
      :tweet => "Tweet",
      :comments => "Comments",
      :url => "Url",
      :influencer_id => 1,
      :advertiser_id => 1,
      :influencer_approved => false,
      :advertiser_approved => false,
      :campaign_id => 1,
      :status => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tweet/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Comments/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
