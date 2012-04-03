require 'spec_helper'

describe "tweet_details/show.html.haml" do
  before(:each) do
    @tweet_detail = assign(:tweet_detail, stub_model(TweetDetail,
      :tweet_id => 1,
      :clicks => 1,
      :retweets => 1,
      :status => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
