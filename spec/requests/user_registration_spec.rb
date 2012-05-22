require "spec_helper"

describe "user registration" do
  it "allows new users to register with an email address and password" do
    visit "/users/new_advertiser"

    user = FactoryGirl.build(:advertiser_user)

    fill_in "user[email]",                             with: user.email
    fill_in "user[password]",                          with: user.password
    fill_in "user[password_confirmation]",             with: user.password_confirmation
    fill_in "user[advertiser_attributes][first_name]", with: user.advertiser.first_name
    fill_in "user[advertiser_attributes][last_name]",  with: user.advertiser.last_name
    fill_in "user[advertiser_attributes][company]",    with: user.advertiser.company
    fill_in "user[advertiser_attributes][phone]",      with: user.advertiser.phone

    click_button "Registrarse"

    puts "MIRA: #{User.count}"

    page.should have_content("Welcome! You have signed up successfully.")
  end
end

