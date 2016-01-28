require 'rails_helper'

RSpec.describe Speciality, type: :model do
  subject {FactoryGirl.create :speciality}
  it {expect(subject).to validate_presence_of(:name)}
end
