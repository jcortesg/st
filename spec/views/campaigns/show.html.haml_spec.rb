require 'spec_helper'

describe "campaigns/show.html.haml" do
  before(:each) do
    @campaign = assign(:campaign, stub_model(Campaign,
      :name => "Name",
      :description => "Description",
      :status => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
