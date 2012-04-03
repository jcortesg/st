require 'spec_helper'

describe "tweet_details/new.html.haml" do
  before(:each) do
    assign(:tweet_detail, stub_model(TweetDetail,
      :tweet_id => 1,
      :clicks => 1,
      :retweets => 1,
      :status => "MyText"
    ).as_new_record)
  end

  it "renders new tweet_detail form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tweet_details_path, :method => "post" do
      assert_select "input#tweet_detail_tweet_id", :name => "tweet_detail[tweet_id]"
      assert_select "input#tweet_detail_clicks", :name => "tweet_detail[clicks]"
      assert_select "input#tweet_detail_retweets", :name => "tweet_detail[retweets]"
      assert_select "textarea#tweet_detail_status", :name => "tweet_detail[status]"
    end
  end
end
