require 'spec_helper'

describe "locations/show.html.haml" do
  before(:each) do
    @location = assign(:location, stub_model(Location,
      :suburb => "Suburb",
      :city => "City",
      :state => "State",
      :country => "Country"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Suburb/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Country/)
  end
end
