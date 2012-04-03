require 'spec_helper'

describe "audiences_locations/edit.html.haml" do
  before(:each) do
    @audiences_location = assign(:audiences_location, stub_model(AudiencesLocation,
      :audience_id => 1,
      :location_id => 1,
      :percentage => "9.99"
    ))
  end

  it "renders the edit audiences_location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => audiences_locations_path(@audiences_location), :method => "post" do
      assert_select "input#audiences_location_audience_id", :name => "audiences_location[audience_id]"
      assert_select "input#audiences_location_location_id", :name => "audiences_location[location_id]"
      assert_select "input#audiences_location_percentage", :name => "audiences_location[percentage]"
    end
  end
end
