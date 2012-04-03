require 'spec_helper'

describe "audiences/edit.html.haml" do
  before(:each) do
    @audience = assign(:audience, stub_model(Audience,
      :influencer_id => 1,
      :followers => 1,
      :followers_followers => 1,
      :males => "9.99",
      :females => "9.99",
      :moms => "9.99",
      :kids => "9.99",
      :young_teens => "9.99",
      :mature_teens => "9.99",
      :young_adults => "9.99",
      :mature_adults => "9.99",
      :adults => "9.99",
      :elderly => "9.99",
      :sports => "9.99",
      :fashion => "9.99",
      :music => "9.99",
      :movies => "9.99",
      :politics => "9.99"
    ))
  end

  it "renders the edit audience form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => audiences_path(@audience), :method => "post" do
      assert_select "input#audience_influencer_id", :name => "audience[influencer_id]"
      assert_select "input#audience_followers", :name => "audience[followers]"
      assert_select "input#audience_followers_followers", :name => "audience[followers_followers]"
      assert_select "input#audience_males", :name => "audience[males]"
      assert_select "input#audience_females", :name => "audience[females]"
      assert_select "input#audience_moms", :name => "audience[moms]"
      assert_select "input#audience_kids", :name => "audience[kids]"
      assert_select "input#audience_young_teens", :name => "audience[young_teens]"
      assert_select "input#audience_mature_teens", :name => "audience[mature_teens]"
      assert_select "input#audience_young_adults", :name => "audience[young_adults]"
      assert_select "input#audience_mature_adults", :name => "audience[mature_adults]"
      assert_select "input#audience_adults", :name => "audience[adults]"
      assert_select "input#audience_elderly", :name => "audience[elderly]"
      assert_select "input#audience_sports", :name => "audience[sports]"
      assert_select "input#audience_fashion", :name => "audience[fashion]"
      assert_select "input#audience_music", :name => "audience[music]"
      assert_select "input#audience_movies", :name => "audience[movies]"
      assert_select "input#audience_politics", :name => "audience[politics]"
    end
  end
end
