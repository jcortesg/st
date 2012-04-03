require 'spec_helper'

describe "tweet_details/edit.html.haml" do
  before(:each) do
    @tweet_detail = assign(:tweet_detail, stub_model(TweetDetail,
      :tweet_id => 1,
      :clicks => 1,
      :retweets => 1,
      :status => "MyText"
    ))
  end

  it "renders the edit tweet_detail form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tweet_details_path(@tweet_detail), :method => "post" do
      assert_select "input#tweet_detail_tweet_id", :name => "tweet_detail[tweet_id]"
      assert_select "input#tweet_detail_clicks", :name => "tweet_detail[clicks]"
      assert_select "input#tweet_detail_retweets", :name => "tweet_detail[retweets]"
      assert_select "textarea#tweet_detail_status", :name => "tweet_detail[status]"
    end
  end
end
