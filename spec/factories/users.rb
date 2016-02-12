FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    password {12345678}
    role "applicant"
    resume do
      File.open(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
    end
    factory :employer do
      country {Faker::Address.country_code}
      city {Faker::Address.city}
      role "employer"
    end

    factory :manager do
      role "manager"
    end
    factory :admin do
      role "admin"
    end
  end

end
