require 'spec_helper'

describe "top_followers/new.html.haml" do
  before(:each) do
    assign(:top_follower, stub_model(TopFollower,
      :influencer_id => 1,
      :twitter_username => "MyString",
      :followers => 1,
      :followers_followers => 1,
      :clicks => 1,
      :retweets => 1
    ).as_new_record)
  end

  it "renders new top_follower form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => top_followers_path, :method => "post" do
      assert_select "input#top_follower_influencer_id", :name => "top_follower[influencer_id]"
      assert_select "input#top_follower_twitter_username", :name => "top_follower[twitter_username]"
      assert_select "input#top_follower_followers", :name => "top_follower[followers]"
      assert_select "input#top_follower_followers_followers", :name => "top_follower[followers_followers]"
      assert_select "input#top_follower_clicks", :name => "top_follower[clicks]"
      assert_select "input#top_follower_retweets", :name => "top_follower[retweets]"
    end
  end
end
