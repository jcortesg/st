require 'spec_helper'

describe "payment_types/show.html.haml" do
  before(:each) do
    @payment_type = assign(:payment_type, stub_model(PaymentType,
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
  end
end
