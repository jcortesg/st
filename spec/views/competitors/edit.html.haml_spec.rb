require 'spec_helper'

describe "competitors/edit.html.haml" do
  before(:each) do
    @competitor = assign(:competitor, stub_model(Competitor,
      :advertiser_id => 1,
      :competitor_id => 1
    ))
  end

  it "renders the edit competitor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => competitors_path(@competitor), :method => "post" do
      assert_select "input#competitor_advertiser_id", :name => "competitor[advertiser_id]"
      assert_select "input#competitor_competitor_id", :name => "competitor[competitor_id]"
    end
  end
end
