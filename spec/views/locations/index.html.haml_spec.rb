require 'spec_helper'

describe "locations/index.html.haml" do
  before(:each) do
    assign(:locations, [
      stub_model(Location,
        :suburb => "Suburb",
        :city => "City",
        :state => "State",
        :country => "Country"
      ),
      stub_model(Location,
        :suburb => "Suburb",
        :city => "City",
        :state => "State",
        :country => "Country"
      )
    ])
  end

  it "renders a list of locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Suburb".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
