FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@borwin.net"
  end

  factory :user do
    email
    password 'password'
    password_confirmation 'password'
  end

  factory :advertiser do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    company Faker::Company.name
    phone Faker::PhoneNumber.phone_number
  end

  factory :advertiser_user, parent: :user do
    association :advertiser, factory: :advertiser
  end

  factory :affiliate do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    company Faker::Company.name
    phone Faker::PhoneNumber.phone_number
  end

  factory :affiliate_user, parent: :user do
    association :affiliate, factory: :affiliate
  end

  factory :influencer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    influencer_type Influencer.influencer_types.sample
  end

  factory :influencer_user, parent: :user do
    twitter_screen_name 'rorra'
    twitter_token '1'
    twitter_secret '2'
    association :influencer, factory: :influencer, strategy: :build
    twitter_linked true
  end

end