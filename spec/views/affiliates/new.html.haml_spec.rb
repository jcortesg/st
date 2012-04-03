require 'spec_helper'

describe "affiliates/new.html.haml" do
  before(:each) do
    assign(:affiliate, stub_model(Affiliate,
      :user_id => 1,
      :firstname => "MyString",
      :lastname => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString",
      :zip_code => 1,
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new affiliate form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => affiliates_path, :method => "post" do
      assert_select "input#affiliate_user_id", :name => "affiliate[user_id]"
      assert_select "input#affiliate_firstname", :name => "affiliate[firstname]"
      assert_select "input#affiliate_lastname", :name => "affiliate[lastname]"
      assert_select "input#affiliate_address", :name => "affiliate[address]"
      assert_select "input#affiliate_city", :name => "affiliate[city]"
      assert_select "input#affiliate_state", :name => "affiliate[state]"
      assert_select "input#affiliate_country", :name => "affiliate[country]"
      assert_select "input#affiliate_zip_code", :name => "affiliate[zip_code]"
      assert_select "input#affiliate_phone", :name => "affiliate[phone]"
    end
  end
end
