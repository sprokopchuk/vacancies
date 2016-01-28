require 'rails_helper'

RSpec.describe Company, type: :model do
  subject {FactoryGirl.create :company}
  it {expect(subject).to validate_presence_of(:name)}
  it {expect(subject).to belong_to(:user)}
end
