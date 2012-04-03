require 'spec_helper'

describe "top_followers/show.html.haml" do
  before(:each) do
    @top_follower = assign(:top_follower, stub_model(TopFollower,
      :influencer_id => 1,
      :twitter_username => "Twitter Username",
      :followers => 1,
      :followers_followers => 1,
      :clicks => 1,
      :retweets => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Twitter Username/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
