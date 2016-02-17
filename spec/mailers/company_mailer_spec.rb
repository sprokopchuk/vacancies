require "rails_helper"

RSpec.describe CompanyMailer, type: :mailer do
  let(:user){FactoryGirl.build_stubbed :user}
  let(:company) {FactoryGirl.build_stubbed :company}
  let(:email) {CompanyMailer.denial_email user, company}

  it "renders the subject by default" do
    expect(email.subject).to eq("From company #{company.name.capitalize}")
  end

  it "renders the subject if employer want to change a default subject" do
    other_email = CompanyMailer.denial_email(user, company, {subject: "Bla", body: "Gla"})
    expect(other_email.subject).to eq("Bla")
  end

  it "renders the receiver email" do
    expect(email.to).to eq([user.email])
  end

  it "renders the sender email" do
    expect(email.from).to eq(["notifications@localhost.com"])
  end

  it "assigns @user" do
    expect(email.body.encoded).to match(user.full_name)
  end

  it "assigns @company" do
    expect(email.body.encoded).to match(company.name)
  end

  it "chnage a body if employer changed a default body" do
    other_email = CompanyMailer.denial_email(user, company, {subject: "Bla", body: "Gla"})
    expect(other_email.body.encoded).to match("Gla")
  end
end
