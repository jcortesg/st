require 'spec_helper'

describe "locations/new.html.haml" do
  before(:each) do
    assign(:location, stub_model(Location,
      :suburb => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString"
    ).as_new_record)
  end

  it "renders new location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => locations_path, :method => "post" do
      assert_select "input#location_suburb", :name => "location[suburb]"
      assert_select "input#location_city", :name => "location[city]"
      assert_select "input#location_state", :name => "location[state]"
      assert_select "input#location_country", :name => "location[country]"
    end
  end
end
