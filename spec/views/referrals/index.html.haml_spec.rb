require 'spec_helper'

describe "referrals/index.html.haml" do
  before(:each) do
    assign(:referrals, [
      stub_model(Referral,
        :source_id => 1,
        :destination_id => 1,
        :commission => "9.99"
      ),
      stub_model(Referral,
        :source_id => 1,
        :destination_id => 1,
        :commission => "9.99"
      )
    ])
  end

  it "renders a list of referrals" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
