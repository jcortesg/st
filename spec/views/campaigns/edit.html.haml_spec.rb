require 'spec_helper'

describe "campaigns/edit.html.haml" do
  before(:each) do
    @campaign = assign(:campaign, stub_model(Campaign,
      :name => "MyString",
      :description => "MyString",
      :status => "MyText"
    ))
  end

  it "renders the edit campaign form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => campaigns_path(@campaign), :method => "post" do
      assert_select "input#campaign_name", :name => "campaign[name]"
      assert_select "input#campaign_description", :name => "campaign[description]"
      assert_select "textarea#campaign_status", :name => "campaign[status]"
    end
  end
end
