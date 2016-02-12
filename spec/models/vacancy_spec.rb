require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  subject {FactoryGirl.create :vacancy}
  let(:opened_vacancies) {FactoryGirl.create_list(:vacancy, 3)}
  let(:archived_vacancies) {FactoryGirl.create_list(:archived_vacancy, 3)}
  let(:authenticated_user) {FactoryGirl.create :user, resume: nil}
  let(:employer) {FactoryGirl.create :employer}
  it {expect(subject).to validate_presence_of(:title)}
  it {expect(subject).to validate_presence_of(:description)}
  it {expect(subject).to validate_presence_of(:deadline)}
  it {expect(subject).to belong_to(:company)}
  it {expect(subject).to belong_to(:speciality)}

  context "by default" do
    it "return the list of opened vacancies" do
      expect(Vacancy.all).to match_array(opened_vacancies)
    end

    it "doesn't return the list of opened vacancies" do
      expect(Vacancy.all).not_to match_array(archived_vacancies)
    end
  end

  context ".archived" do
    it "return the list of archived vacancies" do
      expect(Vacancy.archived).to match_array(archived_vacancies)
    end

    it "doesn't return the list of archived vacancies" do
      expect(Vacancy.archived).not_to match_array(opened_vacancies)
    end
  end

  context "#close" do
    it "return true while putting vacancy into archive" do
      expect(subject.close).to be_truthy
    end

    it "change date of deadline" do
      expect{subject.close}.to change{subject.deadline}
    end

    it "put vacancy into archive" do
      subject.close
      expect(Vacancy.all).to match_array([])
    end
  end
  context "#attach_resume" do
    it "return nil if resume already is attached to vacancy" do
      subject.attach_resume(authenticated_user, authenticated_user.resume.to_s)
      expect(
        subject.attach_resume(authenticated_user, authenticated_user.resume.to_s)
        ).to eq nil
    end


    it "attach resume first time" do
      file = File.open(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
      subject.attach_resume(authenticated_user, file)
      expect(authenticated_user.resume_identifier).to eq "logo_image.png"
    end

    it "return a user's list of applied jobs which attached resume" do
      expect(
        subject.attach_resume(authenticated_user, authenticated_user.resume.to_s)
        ).to eq authenticated_user.vacancies
    end

    it "change numbers of users are attached resume to vacancy" do
      expect{
        subject.attach_resume(authenticated_user, authenticated_user.resume.to_s)
        }.to change{subject.reload.users.size}.by(1)
    end
  end

  context "#can_applly?" do

    it "return false if user is employer" do
       expect(archived_vacancies[0].can_applly? employer).to be_falsey
    end
    it "return false if vacancy is archived" do
      expect(archived_vacancies[0].can_applly? authenticated_user).to be_falsey
    end

    it "return false if user is not sign in" do
      expect(subject.can_applly? nil).to be_falsey
    end
    it "return true if vacancy is opened" do
      expect(subject.can_applly? authenticated_user).to be_truthy
    end

    it "return false if user is already applied resume to vacancy" do
      subject.attach_resume(authenticated_user, authenticated_user.resume.to_s)
      expect(subject.can_applly? authenticated_user).to be_falsey
    end

    it "return true if user is not applied resume to vacancy" do
      expect(subject.can_applly? authenticated_user).to be_truthy
    end
  end
end
