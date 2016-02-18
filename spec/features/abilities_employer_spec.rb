require 'rails_helper'

feature 'Employer' do
  given(:employer) {FactoryGirl.create :employer, approved: true}
  given(:company) {FactoryGirl.create :company, user: employer}
  given(:vacancy) {FactoryGirl.build :vacancy}
  given(:user) {FactoryGirl.create :user}
  given(:specialities) {FactoryGirl.create_list :speciality, 3}
  background do
    login_as employer, scope: :user
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

  scenario 'generate new invite code' do
    click_link "Invite codes"
    click_link "Generate an new invite code"
    expect(page).to have_content(employer.invite_codes[0].code)
  end

  scenario 'see the list of vacancies of own company' do
    vacancy.company_id = employer.company.id
    vacancy.save
    click_link "My company"
    expect(page).to have_link vacancy.title.capitalize
  end

  scenario 'close a vacancy' do
    vacancy.company_id = employer.company.id
    vacancy.save
    click_link "My company"
    click_link "", :href => close_vacancy_path(vacancy, :company_id => company.id)
    expect(page).to have_content("Vacancy is closed")
  end

  scenario 'see applied resume in vacancy' do
    vacancy.company_id = employer.company.id
    vacancy.save
    vacancy.attach_resume user, File.new(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
    click_link "My company"
    click_link vacancy.title.capitalize
    expect(page).to have_content user.full_name
  end

  scenario "download applicant's resume applied to vacancy" do
    vacancy.company_id = employer.company.id
    vacancy.save
    vacancy.attach_resume user, File.new(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
    click_link "My company"
    click_link vacancy.title.capitalize
    click_link "Download", :href => download_resume_user_path(user, vacancy_id: vacancy.id)
    expect(response_headers['Content-Type']).to eq "image/png"
  end

  scenario 'see own profile' do
    click_link "My profile"
    expect(page).to have_content(employer.full_name)
  end
end