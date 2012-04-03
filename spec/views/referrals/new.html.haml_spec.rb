require 'spec_helper'

describe "referrals/new.html.haml" do
  before(:each) do
    assign(:referral, stub_model(Referral,
      :source_id => 1,
      :destination_id => 1,
      :commission => "9.99"
    ).as_new_record)
  end

  it "renders new referral form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => referrals_path, :method => "post" do
      assert_select "input#referral_source_id", :name => "referral[source_id]"
      assert_select "input#referral_destination_id", :name => "referral[destination_id]"
      assert_select "input#referral_commission", :name => "referral[commission]"
    end
  end
end
