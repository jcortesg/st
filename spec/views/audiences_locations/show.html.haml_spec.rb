require 'spec_helper'

describe "audiences_locations/show.html.haml" do
  before(:each) do
    @audiences_location = assign(:audiences_location, stub_model(AudiencesLocation,
      :audience_id => 1,
      :location_id => 1,
      :percentage => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
  end
end
