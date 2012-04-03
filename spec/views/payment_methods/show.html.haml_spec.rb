require 'spec_helper'

describe "payment_methods/show.html.haml" do
  before(:each) do
    @payment_method = assign(:payment_method, stub_model(PaymentMethod,
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
