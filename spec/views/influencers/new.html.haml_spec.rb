require 'spec_helper'

describe "influencers/new.html.haml" do
  before(:each) do
    assign(:influencer, stub_model(Influencer,
      :user_id => 1,
      :twitter_username => "MyString",
      :borwin_fee => "9.99",
      :firstname => "MyString",
      :lastname => "MyString",
      :sex => "MyText",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString",
      :zip_code => 1,
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new influencer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => influencers_path, :method => "post" do
      assert_select "input#influencer_user_id", :name => "influencer[user_id]"
      assert_select "input#influencer_twitter_username", :name => "influencer[twitter_username]"
      assert_select "input#influencer_borwin_fee", :name => "influencer[borwin_fee]"
      assert_select "input#influencer_firstname", :name => "influencer[firstname]"
      assert_select "input#influencer_lastname", :name => "influencer[lastname]"
      assert_select "textarea#influencer_sex", :name => "influencer[sex]"
      assert_select "input#influencer_address", :name => "influencer[address]"
      assert_select "input#influencer_city", :name => "influencer[city]"
      assert_select "input#influencer_state", :name => "influencer[state]"
      assert_select "input#influencer_country", :name => "influencer[country]"
      assert_select "input#influencer_zip_code", :name => "influencer[zip_code]"
      assert_select "input#influencer_phone", :name => "influencer[phone]"
    end
  end
end
