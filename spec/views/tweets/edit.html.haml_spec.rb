require 'spec_helper'

describe "tweets/edit.html.haml" do
  before(:each) do
    @tweet = assign(:tweet, stub_model(Tweet,
      :tweet => "MyString",
      :comments => "MyString",
      :url => "MyString",
      :influencer_id => 1,
      :advertiser_id => 1,
      :influencer_approved => false,
      :advertiser_approved => false,
      :campaign_id => 1,
      :status => "MyText"
    ))
  end

  it "renders the edit tweet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tweets_path(@tweet), :method => "post" do
      assert_select "input#tweet_tweet", :name => "tweet[tweet]"
      assert_select "input#tweet_comments", :name => "tweet[comments]"
      assert_select "input#tweet_url", :name => "tweet[url]"
      assert_select "input#tweet_influencer_id", :name => "tweet[influencer_id]"
      assert_select "input#tweet_advertiser_id", :name => "tweet[advertiser_id]"
      assert_select "input#tweet_influencer_approved", :name => "tweet[influencer_approved]"
      assert_select "input#tweet_advertiser_approved", :name => "tweet[advertiser_approved]"
      assert_select "input#tweet_campaign_id", :name => "tweet[campaign_id]"
      assert_select "textarea#tweet_status", :name => "tweet[status]"
    end
  end
end
