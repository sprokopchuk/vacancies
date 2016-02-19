require 'rails_helper'

feature 'Companies' do

  given(:employer) {FactoryGirl.create :employer, approved: true}
  given(:company) {FactoryGirl.create :company, user: employer}
  given(:user) {FactoryGirl.create :user}

  background do
    login_as employer, scope: :user
    visit company_path(company)
  end

  scenario 'update information', js: true do
    click_link "", href: edit_company_path(company)
    chosen_select "Andorra", from: "#company_country"
    chosen_select "Encamp", from: "#company_state"
    chosen_select "Encamp", from: "#company_city"
    fill_in "company[name]", with: "My company"
    fill_in "company[description]", with: "Building organization"
    click_button "Update company"
    expect(page).to have_content "Information about company was successfully updated"
  end
end