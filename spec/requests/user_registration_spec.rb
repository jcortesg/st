require "spec_helper"

describe "user registration" do
  it "allows advertisers to register" do
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

    page.should have_content("Tu cuenta fue creada.")
  end

  it "allows affiliates to register" do
    visit "/users/new_affiliate"

    user = FactoryGirl.build(:affiliate_user)

    fill_in "user[email]",                            with: user.email
    fill_in "user[password]",                         with: user.password
    fill_in "user[password_confirmation]",            with: user.password_confirmation
    fill_in "user[affiliate_attributes][first_name]", with: user.affiliate.first_name
    fill_in "user[affiliate_attributes][last_name]",  with: user.affiliate.last_name
    fill_in "user[affiliate_attributes][phone]",      with: user.affiliate.phone

    click_button "Registrarse"

    page.should have_content("Tu cuenta fue creada.")
  end

  it "allows influencers to register" do
    login_with_oauth

    user = FactoryGirl.build(:influencer_user)

    fill_in "user[email]",                                  with: user.email
    fill_in "user[password]",                               with: user.password
    fill_in "user[password_confirmation]",                  with: user.password_confirmation
    fill_in "user[influencer_attributes][first_name]",      with: user.influencer.first_name
    fill_in "user[influencer_attributes][last_name]",       with: user.influencer.last_name
    select user.influencer.influencer_type, from: "user[influencer_attributes][influencer_type]"

    click_button "Registrarse"

    page.should have_content("Datos de contacto")
  end
end

