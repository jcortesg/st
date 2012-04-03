require 'spec_helper'

describe "advertisers/new.html.haml" do
  before(:each) do
    assign(:advertiser, stub_model(Advertiser,
      :user_id => 1,
      :twitter_username => "MyString",
      :borwin_fee => "9.99",
      :brand => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString",
      :zip_code => 1,
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new advertiser form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => advertisers_path, :method => "post" do
      assert_select "input#advertiser_user_id", :name => "advertiser[user_id]"
      assert_select "input#advertiser_twitter_username", :name => "advertiser[twitter_username]"
      assert_select "input#advertiser_borwin_fee", :name => "advertiser[borwin_fee]"
      assert_select "input#advertiser_brand", :name => "advertiser[brand]"
      assert_select "input#advertiser_address", :name => "advertiser[address]"
      assert_select "input#advertiser_city", :name => "advertiser[city]"
      assert_select "input#advertiser_state", :name => "advertiser[state]"
      assert_select "input#advertiser_country", :name => "advertiser[country]"
      assert_select "input#advertiser_zip_code", :name => "advertiser[zip_code]"
      assert_select "input#advertiser_phone", :name => "advertiser[phone]"
    end
  end
end
