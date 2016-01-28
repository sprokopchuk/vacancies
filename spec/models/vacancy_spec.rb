require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  subject {FactoryGirl.create :vacancy}
  it {expect(subject).to validate_presence_of(:title)}
  it {expect(subject).to validate_presence_of(:description)}
  it {expect(subject).to validate_presence_of(:deadline)}
  it {expect(subject).to belong_to(:company)}
end
