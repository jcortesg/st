require "spec_helper"

describe "user registration" do
  it "allows new users to register with an email address and password" do
    visit "/users/new_advertiser"

    fill_in "user_email",                 :with => "test@borwin.net"
    fill_in "user_password",              :with => "borwin123"
    fill_in "user_password_confirmation", :with => "borwin123"

    click_button "Registrarse"

    page.should have_content("Welcome! You have signed up successfully.")
  end
end

