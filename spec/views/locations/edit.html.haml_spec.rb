require 'spec_helper'

describe "locations/edit.html.haml" do
  before(:each) do
    @location = assign(:location, stub_model(Location,
      :suburb => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString"
    ))
  end

  it "renders the edit location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => locations_path(@location), :method => "post" do
      assert_select "input#location_suburb", :name => "location[suburb]"
      assert_select "input#location_city", :name => "location[city]"
      assert_select "input#location_state", :name => "location[state]"
      assert_select "input#location_country", :name => "location[country]"
    end
  end
end
