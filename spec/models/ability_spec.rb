require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:employer_user) {FactoryGirl.create :employer}
  let(:company) {FactoryGirl.create :company, user: employer_user}
  let(:vacancy) {FactoryGirl.create :vacancy, company: company}
  let(:other_vacancy) {FactoryGirl.create :vacancy}
  let(:applicant_user) {FactoryGirl.create :user}
  describe "abilities for employer" do
    subject{Ability.new(employer_user)}
    context "for vacancies" do
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).to be_able_to(:create, Vacancy)}
      it {expect(subject).to be_able_to(:update, vacancy)}
      it {expect(subject).to be_able_to(:destroy, vacancy)}
      it {expect(subject).to be_able_to(:read, other_vacancy)}
      it {expect(subject).not_to be_able_to(:update, other_vacancy)}
      it {expect(subject).not_to be_able_to(:destroy, other_vacancy)}
    end
  end

  describe "abilities for applicant" do
    subject {Ability.new(applicant_user)}
    context "for vacancies" do
      it {expect(subject).to be_able_to(:attach_resume, vacancy)}
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).not_to be_able_to(:create, Vacancy)}
      it {expect(subject).not_to be_able_to(:update, vacancy)}
      it {expect(subject).not_to be_able_to(:destroy, vacancy)}
    end
  end
end