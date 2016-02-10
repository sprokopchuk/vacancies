require 'rails_helper'

RSpec.describe User, type: :model do
  subject{FactoryGirl.create :user}
  let(:company) {FactoryGirl.create :company}
  let(:employer) {FactoryGirl.create :employer, company: company}
  it {expect(subject).to validate_presence_of(:first_name)}
  it {expect(subject).to validate_presence_of(:last_name)}
  it {expect(subject).to belong_to(:speciality)}
  it {expect(subject).not_to validate_presence_of(:company)}

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

  context "#get_country" do
    it "return applicant's country if country is set" do
      subject.country = "US"
      expect(subject.get_country).to eq CS.countries[subject.country.upcase.to_sym]
    end

    it "return nil if applicant's country is not set" do
      expect(subject.get_country).to eq nil
    end

    it "return employer's country if company is set" do
      expect(employer.get_country).to eq CS.countries[company.country.upcase.to_sym]
    end

    it "return nil if employer's company is not set" do
      employer.company = nil
      expect(employer.get_country).to eq nil
    end
  end

  context "#current?" do
    it "return true if current user is own page profile" do
      expect(subject.current? subject.id).to be_truthy
    end

    it "return false if employer on applicant's page profile" do
      expect(subject.current? employer.id).to be_falsey
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
