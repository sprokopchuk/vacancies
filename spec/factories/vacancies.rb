FactoryGirl.define do
  factory :vacancy do
    title {Faker::Lorem.word}
    deadline {Faker::Date.forward(23)}
    description {Faker::Lorem.paragraph}
  end

end
