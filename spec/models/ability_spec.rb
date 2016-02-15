require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:admin) {FactoryGirl.create :admin}
  let(:employer_user) {FactoryGirl.create :employer}
  let(:manager) {FactoryGirl.create :manager}
  let(:company) {FactoryGirl.create :company, user: employer_user}
  let(:other_company) {FactoryGirl.create :company}
  let(:vacancy) {FactoryGirl.create :vacancy, company: company}
  let(:other_vacancy) {FactoryGirl.create :vacancy}
  let(:applicant_user) {FactoryGirl.create :user}
  let(:other_applicant_user) {FactoryGirl.create :user}
  let(:invite_codes) {FactoryGirl.create :invite_code, user: employer_user}
  describe "abilities for admin" do
    subject {Ability.new(admin)}

    context "for vacancies" do
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).not_to be_able_to(:create, Vacancy)}
      it {expect(subject).not_to be_able_to(:close, vacancy)}
      it {expect(subject).not_to be_able_to(:attach_resume, vacancy)}
      it {expect(subject).to be_able_to(:charts, Vacancy)}
    end

    context "for users" do
      it {expect(subject).to be_able_to(:read, employer_user)}
      it {expect(subject).to be_able_to(:toggle, employer_user)}
    end
    context "for companies" do
      it {expect(subject).to be_able_to(:read, company)}
      it {expect(subject).to be_able_to(:update, company)}
    end
  end

  describe "abilities for manager" do
    subject{Ability.new(manager)}

    context "for vacancies" do
      before do
        manager.update invite_code: FactoryGirl.create(:invite_code, user: employer_user).code
      end
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).to be_able_to(:close, vacancy)}
      it {expect(subject).to be_able_to(:create, Vacancy)}
      it {expect(subject).not_to be_able_to(:close, other_vacancy)}
    end

    context "for companies" do
      it {expect(subject).to be_able_to(:read, other_company)}
      it {expect(subject).not_to be_able_to(:update, company)}
      it {expect(subject).not_to be_able_to(:create, Company)}
    end

    context "for users" do
      it {expect(subject).to be_able_to(:read, applicant_user)}
      it {expect(subject).to be_able_to(:download_resume, applicant_user)}
    end
  end
  describe "abilities for employer" do
    subject{Ability.new(employer_user)}
    context "for vacancies" do
      context "can't manage own vacancies if employer is not approved" do
        it {expect(subject).not_to be_able_to(:create, Vacancy)}
      end

      context "can manage own vacancies if employer is approved" do
        before do
          employer_user.update(:approved => true)
        end
        it {expect(subject).to be_able_to(:create, Vacancy)}
        it {expect(subject).to be_able_to(:close, vacancy)}
      end
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).to be_able_to(:read, other_vacancy)}
    end

    context "for companies" do
      context "can't manage company if employer is not approved" do
        it {expect(subject).not_to be_able_to(:create, Company)}
        it {expect(subject).not_to be_able_to(:update, company)}
      end

      context "can't manage other company" do
        before do
          employer_user.update(:approved => true)
        end
        it {expect(subject).not_to be_able_to(:update, other_company)}
        it {expect(subject).to be_able_to(:read, other_company)}
      end
      context "can manage company if employer is approved" do
        before do
          employer_user.update(:approved => true)
        end
        it {expect(subject).to be_able_to(:read, company)}
        it {expect(subject).to be_able_to(:create, Company)}
        it {expect(subject).to be_able_to(:update, company)}
      end
    end

    context "for users" do
      it "can download resume if employer is approved" do
        employer_user.update(:approved => true)
        expect(subject).to be_able_to(:download_resume, applicant_user)
      end
      it "can't download resume if employer is not approved" do
        expect(subject).not_to be_able_to(:download_resume, applicant_user)
      end

      it "can read user's resume if employer is approved" do
        employer_user.update(:approved => true)
        expect(subject).to be_able_to(:read, applicant_user)
      end
    end

    context "for invite codes" do
      before do
        employer_user.update(:approved => true)
      end
      it {expect(subject).to be_able_to(:read, invite_codes)}
      it {expect(subject).to be_able_to(:create, InviteCode)}
      it {expect(subject).not_to be_able_to(:read, FactoryGirl.create(:invite_code))}
    end
  end

  describe "abilities for applicant" do
    subject {Ability.new(applicant_user)}
    context "for vacancies" do

      it {expect(subject).to be_able_to(:attach_resume, vacancy)}
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).not_to be_able_to(:create, Vacancy)}
    end

    context "for companies" do
      it {expect(subject).to be_able_to(:read, company)}
      it {expect(subject).not_to be_able_to(:create, Company)}
      it {expect(subject).not_to be_able_to(:update, company)}

    end

    context "for users" do
      it {expect(subject).to be_able_to(:read, applicant_user)}
      it {expect(subject).not_to be_able_to(:read, other_applicant_user)}
      it {expect(subject).to be_able_to(:download_resume, applicant_user)}
      it {expect(subject).not_to be_able_to(:download_resume, other_applicant_user)}
    end
  end

  describe "abilities for guests" do
    subject {Ability.new(nil)}
    context "for vacancies" do
      it {expect(subject).not_to be_able_to(:attach_resume, vacancy)}
      it {expect(subject).to be_able_to(:read, vacancy)}
      it {expect(subject).not_to be_able_to(:create, Vacancy)}
    end

    context "for companies" do
      it {expect(subject).to be_able_to(:read, company)}
      it {expect(subject).not_to be_able_to(:create, Company)}
      it {expect(subject).not_to be_able_to(:update, company)}
    end

    context "for users" do
      it {expect(subject).not_to be_able_to(:download_resume, applicant_user)}
      it {expect(subject).not_to be_able_to(:read, applicant_user)}
    end
  end
end