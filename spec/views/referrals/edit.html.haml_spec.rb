require 'spec_helper'

describe "referrals/edit.html.haml" do
  before(:each) do
    @referral = assign(:referral, stub_model(Referral,
      :source_id => 1,
      :destination_id => 1,
      :commission => "9.99"
    ))
  end

  it "renders the edit referral form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => referrals_path(@referral), :method => "post" do
      assert_select "input#referral_source_id", :name => "referral[source_id]"
      assert_select "input#referral_destination_id", :name => "referral[destination_id]"
      assert_select "input#referral_commission", :name => "referral[commission]"
    end
  end
end
