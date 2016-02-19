require 'rails_helper'

feature 'Emails', js: true do

  given(:employer) {FactoryGirl.create :employer, approved: true}
  given(:company) {FactoryGirl.create :company, user: employer}
  given(:vacancy) {FactoryGirl.create :vacancy, company: company}
  given(:user) {FactoryGirl.create :user}

  background do
    login_as employer, scope: :user
    company
    vacancy.attach_resume user, File.new(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
    visit root_path
  end

  scenario 'show email form' do
    click_link vacancy.title.capitalize
    click_link "Send or Edit email", :href => new_email_user_path(user)
    expect(page).to have_content "You may leave fields are blank and will be sent default denial email"
  end

  scenario 'send default denial email' do
    click_link vacancy.title.capitalize
    click_link "Send or Edit email", :href => new_email_user_path(user)
    click_button "Send Email"
    expect(page).to have_content "Denial email was successfully sent"
  end


  scenario "send denial email with changed subject and body" do
    click_link vacancy.title.capitalize
    click_link "Send or Edit email", :href => new_email_user_path(user)
    within "#denial_email_form" do
      fill_in "denial_email[subject]", with: "Bla Bla"
      fill_in "denial_email[body]", with: "Gla"
    end
    click_button "Send Email"
    expect(page).to have_content "Denial email was successfully sent"
  end
end