require 'factory_girl_rails'
require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if User.any? || Company.any? || Vacancy.any? || Speciality.any?
  User.delete_all
  Company.delete_all
  Vacancy.unscoped.delete_all
  Speciality.delete_all
  puts "All is gone"
else
  countries = CountryStateSelect.countries_collection
  first_country = countries[54].last
  second_country = countries[6].last
  third_country = countries[15].last
  states_for_first_country = CountryStateSelect.collect_states first_country
  states_for_second_country = CountryStateSelect.collect_states second_country
  states_for_third_country = CountryStateSelect.collect_states third_country
  first_cities = CountryStateSelect.collect_cities(states_for_first_country[5].last, first_country)
  second_cities = CountryStateSelect.collect_cities(states_for_second_country[4].last, second_country)
  third_cities = CountryStateSelect.collect_cities(states_for_third_country[4].last, third_country)
  user = FactoryGirl.create(:user, email: "admin@admin.com")
  employer = FactoryGirl.create(:employer, email: "employer@admin.com")
  puts "Create users"
  com = FactoryGirl.create(:company, user: employer)
  puts "Create company"
  profs = FactoryGirl.create_list :speciality, 4
  puts "Create professions"
  10.times.each do
    FactoryGirl.create :vacancy,
      company: com,
      speciality: profs[0],
      country: first_country,
      city: first_cities[0]
  end

  10.times.each do
    FactoryGirl.create :vacancy,
    company: FactoryGirl.create(:company),
    speciality: profs[1],
    country: second_country,
    city: second_cities[0]
  end

  10.times.each do
    FactoryGirl.create :vacancy,
    company: com,
    speciality: profs[2],
    country: third_country,
    city: third_cities[0]
  end

  10.times.each do
    FactoryGirl.create :vacancy,
    company: FactoryGirl.create(:company),
    speciality: profs[3],
    country: second_country,
    city: second_cities[0]
  end

  10.times.each do
    FactoryGirl.create :archived_vacancy,
    company: com,
    speciality: profs[3],
    country: first_country,
    city: first_cities[0]
  end

  puts "Create vacancies"
end

