require 'spec_helper'

describe "competitors/show.html.haml" do
  before(:each) do
    @competitor = assign(:competitor, stub_model(Competitor,
      :advertiser_id => 1,
      :competitor_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
