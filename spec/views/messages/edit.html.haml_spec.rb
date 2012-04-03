require 'spec_helper'

describe "messages/edit.html.haml" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :source_id => 1,
      :destination_id => 1,
      :title => "MyString",
      :message => "MyString",
      :read => false
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => messages_path(@message), :method => "post" do
      assert_select "input#message_source_id", :name => "message[source_id]"
      assert_select "input#message_destination_id", :name => "message[destination_id]"
      assert_select "input#message_title", :name => "message[title]"
      assert_select "input#message_message", :name => "message[message]"
      assert_select "input#message_read", :name => "message[read]"
    end
  end
end
