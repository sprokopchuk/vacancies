require 'factory_girl_rails'
require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = FactoryGirl.create(:user, email: "admin@admin.com")
employer = FactoryGirl.create(:employer, email: "employer@admin.com")
puts "Create users"
com = FactoryGirl.create(:company, user: employer)
puts "Create company"
profs = FactoryGirl.create_list :speciality, 4
puts "Create professions"
10.times.each do
  FactoryGirl.create :vacancy, company: com, speciality: profs[0]
end

10.times.each do
  FactoryGirl.create :vacancy, company: com, speciality: profs[1]
end

10.times.each do
  FactoryGirl.create :vacancy, company: com, speciality: profs[2]
end

10.times.each do
  FactoryGirl.create :vacancy, company: com, speciality: profs[3]
end

10.times.each do
  FactoryGirl.create :archived_vacancy, company: com, speciality: profs[3]
end

puts "Create vacancies"

