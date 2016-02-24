require 'rails_helper'

feature 'Applicant' do
  given(:user) {FactoryGirl.create :user}
  given(:vacancy) {FactoryGirl.create :vacancy}
  background do
    login_as user, scope: :user
    vacancy
    visit root_path
  end
  scenario 'attach own resume to the job' do
    click_link "#{vacancy.title.capitalize}"
    attach_file "vacancy[file]", File.join(Rails.root, 'spec', 'support', 'logo_image.png')
    click_button "Send resume"
    expect(page).to have_content('Your resumne was successfully sent.')
  end

  scenario 'see applied jobs' do
    vacancy.attach_resume user, File.new(File.join(Rails.root, 'spec', 'support', 'logo_image.png'))
    click_link "Job List"
    expect(page).to have_link vacancy.title.capitalize
  end

  scenario 'see own profile' do
    click_link "My profile"
    expect(page).to have_content(user.full_name)
  end

  scenario "download own resume in profile" do
    click_link "My profile"
    click_link "Download", :href => download_resume_user_path(user)
    expect(response_headers['Content-Type']).to eq "image/png"
  end

end