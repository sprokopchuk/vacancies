FactoryGirl.define do
  factory :speciality do
    name {Faker::Company.profession}
  end

end
