require 'rails_helper'

RSpec.describe User, type: :model do
  subject{FactoryGirl.create :user}
  it {expect(subject).to validate_presence_of(:first_name)}
  it {expect(subject).to validate_presence_of(:last_name)}
  it {expect(subject).to belong_to(:speciality)}
end
