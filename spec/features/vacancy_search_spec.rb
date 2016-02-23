require 'rails_helper'

feature 'Vacancy search' do

  given(:company) {FactoryGirl.create :company, city: "Dnepr", country: "UA"}
  given(:vacancy) {FactoryGirl.create :vacancy, company: company, deadline: Date.tomorrow}
  given(:other_vacancy) {FactoryGirl.create :vacancy, company: company}
  background do
    other_vacancy
    FactoryGirl.create_list :vacancy, 20
    vacancy
    Vacancy.unscoped.order(:id)
    visit root_path
  end

  scenario "see a other_vacancy but don't see vacancy" do
    expect(page).not_to have_link vacancy.title.capitalize
    expect(page).to have_link other_vacancy.title.capitalize
  end

  scenario 'by clicking link on name of country' do
    click_link "", href: vacancies_path(:country => other_vacancy.country)
    expect(page).to have_link vacancy.title.capitalize
  end

  scenario 'by clicking link on name of company' do
    click_link other_vacancy.company.name
    expect(page).to have_link vacancy.title.capitalize
  end

  scenario 'by clicking link on name of city' do
    click_link other_vacancy.city
    expect(page).to have_link vacancy.title.capitalize
  end

  scenario 'by fill in form of search' do
    fill_in "search", with: other_vacancy.city
    click_button "Search"
    expect(page).to have_link vacancy.title.capitalize
  end
end