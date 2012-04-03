require 'spec_helper'

describe "audiences_locations/index.html.haml" do
  before(:each) do
    assign(:audiences_locations, [
      stub_model(AudiencesLocation,
        :audience_id => 1,
        :location_id => 1,
        :percentage => "9.99"
      ),
      stub_model(AudiencesLocation,
        :audience_id => 1,
        :location_id => 1,
        :percentage => "9.99"
      )
    ])
  end

  it "renders a list of audiences_locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
