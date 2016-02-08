FactoryGirl.define do
  factory :company do
    name {Faker::Company.name}
    description {Faker::Lorem.sentence}
    city {Faker::Address.city}
    country {Faker::Address.country_code}
    state {Faker::Address.state_abbr}

    user
  end
end
