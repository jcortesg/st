require 'spec_helper'

describe "currencies/new.html.haml" do
  before(:each) do
    assign(:currency, stub_model(Currency,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new currency form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => currencies_path, :method => "post" do
      assert_select "input#currency_name", :name => "currency[name]"
      assert_select "input#currency_description", :name => "currency[description]"
    end
  end
end
