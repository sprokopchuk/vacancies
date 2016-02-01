FactoryGirl.define do
  factory :vacancy do
    title {Faker::Lorem.word}
    deadline {Faker::Date::forward(23).to_s}
    description {Faker::Lorem.paragraph}
    city {Faker::Address.city}
    country {Faker::Address.country}
    company
    factory :archived_vacancy do
      deadline {Faker::Date.backward(23)}
    end
  end

end
