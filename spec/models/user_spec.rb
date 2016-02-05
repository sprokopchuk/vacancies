require 'rails_helper'

RSpec.describe User, type: :model do
  subject{FactoryGirl.create :user}
  let(:company) {FactoryGirl.create :company}
  let(:employer) {FactoryGirl.create :employer, company: company}
  it {expect(subject).to validate_presence_of(:first_name)}
  it {expect(subject).to validate_presence_of(:last_name)}
  it {expect(subject).to belong_to(:speciality)}
  it {expect(subject).not_to validate_presence_of(:company)}
  it {expect(employer).to validate_presence_of(:company)}

  context "#role?" do
    it "return true if user is applicant" do
      expect(subject.role? :applicant).to be_truthy
    end

    it "return false if user is employer" do
      expect(subject.role? :employer).to be_falsey
    end

    it "return false if user is admin" do
      expect(subject.role? :admin).to be_falsey
    end
  end

  context "approved fo users" do

    it "approved if user is applicant" do
      expect(subject.approved?).to be_truthy
    end

    it "not approved if user is employer" do
      expect(employer.approved?).to be_falsey
    end
  end
end
