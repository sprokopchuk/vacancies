require 'rails_helper'

RSpec.describe Company, type: :model do
  subject {FactoryGirl.create :company}
  context "if active_or_info?" do
    before do
      allow(subject).to receive(:active_or_info?).and_return true
    end
    it {expect(subject).to validate_presence_of(:name)}
    it {expect(subject).to validate_presence_of(:description)}
  end

  context "unless active_or_info?" do
    before do
      allow(subject).to receive(:active_or_info?).and_return false
    end
    it {expect(subject).not_to validate_presence_of(:name)}
    it {expect(subject).not_to validate_presence_of(:description)}
  end

  context "if active_or_country?" do
    before do
      allow(subject).to receive(:active_or_country?).and_return true
    end

    it {expect(subject).to validate_presence_of(:country)}
  end

  context "unless active_or_country?" do
    before do
      allow(subject).to receive(:active_or_country?).and_return false
    end

    it {expect(subject).not_to validate_presence_of(:country)}
  end

  context "if active_or_city?" do
    before do
      allow(subject).to receive(:active_or_city?).and_return true
    end

    it {expect(subject).to validate_presence_of(:city)}
  end

  context "unless active_or_city?" do
    before do
      allow(subject).to receive(:active_or_city?).and_return false
    end

    it {expect(subject).not_to validate_presence_of(:city)}
  end
  it {expect(subject).to belong_to(:user)}
  it {expect(subject).to have_many(:vacancies)}
end
