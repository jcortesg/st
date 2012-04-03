require 'spec_helper'

describe "referrals/show.html.haml" do
  before(:each) do
    @referral = assign(:referral, stub_model(Referral,
      :source_id => 1,
      :destination_id => 1,
      :commission => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
  end
end
