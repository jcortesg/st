require 'spec_helper'

describe "tweet_details/index.html.haml" do
  before(:each) do
    assign(:tweet_details, [
      stub_model(TweetDetail,
        :tweet_id => 1,
        :clicks => 1,
        :retweets => 1,
        :status => "MyText"
      ),
      stub_model(TweetDetail,
        :tweet_id => 1,
        :clicks => 1,
        :retweets => 1,
        :status => "MyText"
      )
    ])
  end

  it "renders a list of tweet_details" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
