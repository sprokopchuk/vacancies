require 'rails_helper'

feature 'Manager' do
  given(:manager) {FactoryGirl.create :manager, invite_code: invite_code.code}
  given(:employer) {FactoryGirl.create :employer}
  given(:invite_code) {FactoryGirl.create :invite_code, user: employer}
  given(:company) {FactoryGirl.create :company, user: employer}
  given(:vacancy) {FactoryGirl.build :vacancy}
  given(:user) {FactoryGirl.create :user}
  given(:specialities) {FactoryGirl.create_list :speciality, 3}
  background do
    login_as manager, scope: :user
    company
    visit root_path
  end

  scenario 'post a vacancy' do
    specialities
    click_link "Post a vacancy"
    within "#new_vacancy" do
      fill_in "vacancy[title]", with: vacancy.title
      fill_in "vacancy[deadline]", with: Date.current.to_date
      select specialities[1].name, :from => "vacancy[speciality_id]"
      fill_in "vacancy[description]", with: vacancy.description
    end
    click_button "Submit"
    expect(page).to have_content('Vacancy was successfully created.')
  end

  scenario 'see the list of vacancies of own company' do
    vacancy.company_id = manager.get_owner_of_invite_code.company.id
    vacancy.save
    click_link "My company"
    expect(page).to have_link vacancy.title.capitalize
  end

  scenario 'close a vacancy' do
    vacancy.company_id = manager.get_owner_of_invite_code.company.id
    vacancy.save
    click_link "My company"
    click_link "", :href => close_vacancy_path(vacancy, :company_id => company.id)
    expect(page).to have_content("Vacancy is closed")
  end

  scenario 'see applied resume in vacancy' do
    vacancy.company_id = manager.get_owner_of_invite_code.company.id
    vacancy.save
    vacancy.attach_resume user, File.new(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
    click_link "My company"
    click_link vacancy.title.capitalize
    expect(page).to have_content user.full_name
  end

  scenario 'see own profile' do
    click_link "My profile"
    expect(page).to have_content(manager.full_name)
  end
end