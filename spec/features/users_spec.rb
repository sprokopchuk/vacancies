require 'rails_helper'

feature 'Users' do
  given(:user) {FactoryGirl.create :user}
  given(:company) {FactoryGirl.create :company, user: employer}
  given(:employer) {FactoryGirl.create :employer}
  given(:invite_code) {FactoryGirl.create :invite_code, user: employer}

  background do
    visit root_path
  end
  scenario 'sign up as applicant' do
    click_link "Sign Up"
    within "#regisration_user" do
      select "Applicant", :from => "user[role]"
      fill_in "user[first_name]", with: user.first_name
      fill_in "user[last_name]", with: user.last_name
      fill_in "user[email]", with: "applicant@gmail.com"
      fill_in "user[password]", with: user.password
      fill_in "user[password_confirmation]", with: user.password
    end
    click_button "Register"
    expect(page).to have_content(I18n.t("devise.registrations.signed_up"))
  end

  scenario 'sign up as employer' do
    click_link "Sign Up"
    within "#regisration_user" do
      select "Employer", :from => "user[role]"
      fill_in "user[first_name]", with: user.first_name
      fill_in "user[last_name]", with: user.last_name
      fill_in "user[email]", with: "employer@gmail.com"
      fill_in "user[password]", with: user.password
      fill_in "user[password_confirmation]", with: user.password
    end
    click_button "Register"
    expect(page).to have_content(I18n.t("devise.registrations.user.signed_up_but_not_approved"))
  end

  scenario 'sign up as manager', js: true do
    company
    click_link "Sign Up"
    within "#regisration_user" do
      select "Manager", :from => "user[role]"
      fill_in "user[invite_code]", with: invite_code.code
      fill_in "user[first_name]", with: user.first_name
      fill_in "user[last_name]", with: user.last_name
      fill_in "user[email]", with: "manager@gmail.com"
      fill_in "user[password]", with: user.password
      fill_in "user[password_confirmation]", with: user.password
    end
    click_button "Register"
    expect(page).to have_content(I18n.t("devise.registrations.signed_up"))
  end

  scenario 'sign in a user' do
    visit new_user_session_path
    within "#new_user" do
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: user.password
    end
    click_button "Log in"
    expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
  end

  scenario "sign out a user" do
    login_as(user, :scope => :user)
    visit root_path
    click_link "Sign Out!"
    expect(page).to have_content(I18n.t("devise.sessions.signed_out"))
  end

  scenario "edit settings" do
    login_as(user, :scope => :user)
    visit root_path
    click_link "Settings"
    within "#edit_user" do
      fill_in "user[first_name]", with: "BlaBla"
      fill_in "user[current_password]", with: user.password
    end
    click_button "Update information"
    expect(page).to have_content(I18n.t("devise.registrations.updated"))
  end

  scenario 'delete own account' do
    login_as(user, :scope => :user)
    visit root_path
    click_link "Settings"
    click_button "Please remove my account"
    expect(page).to have_content(I18n.t("devise.registrations.destroyed"))
  end
end