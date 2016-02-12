FactoryGirl.define do
  factory :invite_code do
    code {SecureRandom.uuid}
    user
  end
end
