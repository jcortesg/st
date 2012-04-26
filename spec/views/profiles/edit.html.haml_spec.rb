require 'spec_helper'

describe "profiles/edit.html.haml" do
  before(:each) do
    @profile = assign(:profiles, stub_model(Profile,
      :influencer_id => 1,
      :fee => "9.99",
      :cpc => "9.99",
      :fee_cpc => "9.99",
      :cpc_fee => "9.99"
    ))
  end

  it "renders the edit profiles form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => profiles_path(@profile), :method => "post" do
      assert_select "input#profile_influencer_id", :name => "profiles[influencer_id]"
      assert_select "input#profile_fee", :name => "profiles[fee]"
      assert_select "input#profile_cpc", :name => "profiles[cpc]"
      assert_select "input#profile_fee_cpc", :name => "profiles[fee_cpc]"
      assert_select "input#profile_cpc_fee", :name => "profiles[cpc_fee]"
    end
  end
end
