require 'rails_helper'

RSpec.describe User, type: :model do
  subject{FactoryGirl.create :user}
  let(:company) {FactoryGirl.create :company}
  let(:employer) {FactoryGirl.create :employer, company: company}
  let(:vacancy) {FactoryGirl.create :vacancy}
  let(:applied_job) {FactoryGirl.create :applied_job, :user => subject, vacancy: vacancy}
  let(:manager) {FactoryGirl.build :manager, invite_code: invite_code.code}
  let(:invite_code) {FactoryGirl.create :invite_code, user: employer}
  it {expect(subject).to validate_presence_of(:first_name)}
  it {expect(subject).to validate_presence_of(:last_name)}
  it {expect(subject).to belong_to(:speciality)}
  it {expect(subject).not_to validate_presence_of(:company)}

  context "if check_invite_code?" do
    it {expect(manager).to validate_presence_of(:invite_code)}
  end

  context "unless check_invite_code?" do
    it {expect(FactoryGirl.build(:user)).not_to validate_presence_of(:invite_code)}
  end

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

  context "#send_denial_email" do
    it "don't sends email for applicant" do
      expect{subject.send_denial_email(employer)}.not_to change {ActionMailer::Base.deliveries.count}
    end

    it "don't sends email for admin" do
      subject.role = "admin"
      expect{subject.send_denial_email(employer)}.not_to change {ActionMailer::Base.deliveries.count}
    end

    it "sends a mail for employer" do
      expect{employer.send_denial_email(subject)}.to change {ActionMailer::Base.deliveries.count}.by(1)
    end

    it "sends a mail for manager" do
      expect{manager.send_denial_email(subject)}.to change {ActionMailer::Base.deliveries.count}.by(1)
    end
  end
  context "#get_owner_of_invite_code" do
    it "return nil for user who is not manager" do
      expect(subject.get_owner_of_invite_code).to eq nil
    end

    it "return employer user for manager" do
      invite_code.update(:user_id => employer.id)
      manager.save
      expect(manager.get_owner_of_invite_code).to eq(employer)
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


  context "#toggle_viewed" do
    it "toogle attribute :viewed from false into true for applied job" do
      applied_job
      expect{
        subject.toggle_viewed vacancy.id
        }.to change{applied_job.reload.viewed}.from(false).to(true)
    end
  end

  context "#resume_viewed?" do
    it "return true if resume to applied job is viewed by employer" do
      applied_job
      subject.toggle_viewed vacancy.id
      expect(subject.resume_viewed? vacancy.id).to be_truthy
    end

    it "return false if resume to applied job is not viewed by employer" do
      expect(subject.resume_viewed? vacancy.id).to be_falsey
    end
  end


  context "#generate_invite_code" do
    it "return nil if user is applicant" do
      expect(subject.generate_invite_code).to eq nil
    end

    it "return generated invite code if user is employer" do
      expect(employer.generate_invite_code.class).to eq(String)
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
