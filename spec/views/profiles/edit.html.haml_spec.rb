require 'spec_helper'

describe "profiles/edit.html.haml" do
  before(:each) do
    @profile = assign(:profile, stub_model(Profile,
      :influencer_id => 1,
      :fee => "9.99",
      :cpc => "9.99",
      :fee_cpc => "9.99",
      :cpc_fee => "9.99"
    ))
  end

  it "renders the edit profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => profiles_path(@profile), :method => "post" do
      assert_select "input#profile_influencer_id", :name => "profile[influencer_id]"
      assert_select "input#profile_fee", :name => "profile[fee]"
      assert_select "input#profile_cpc", :name => "profile[cpc]"
      assert_select "input#profile_fee_cpc", :name => "profile[fee_cpc]"
      assert_select "input#profile_cpc_fee", :name => "profile[cpc_fee]"
    end
  end
end
