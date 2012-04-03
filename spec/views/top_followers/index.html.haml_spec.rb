require 'spec_helper'

describe "top_followers/index.html.haml" do
  before(:each) do
    assign(:top_followers, [
      stub_model(TopFollower,
        :influencer_id => 1,
        :twitter_username => "Twitter Username",
        :followers => 1,
        :followers_followers => 1,
        :clicks => 1,
        :retweets => 1
      ),
      stub_model(TopFollower,
        :influencer_id => 1,
        :twitter_username => "Twitter Username",
        :followers => 1,
        :followers_followers => 1,
        :clicks => 1,
        :retweets => 1
      )
    ])
  end

  it "renders a list of top_followers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Twitter Username".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
