require 'spec_helper'

describe "profiles/show.html.haml" do
  before(:each) do
    @profile = assign(:profiles, stub_model(Profile,
      :influencer_id => 1,
      :fee => "9.99",
      :cpc => "9.99",
      :fee_cpc => "9.99",
      :cpc_fee => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
  end
end
