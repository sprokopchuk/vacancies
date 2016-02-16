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
  InviteCode.delete_all
  puts "All is gone"
else
   FactoryGirl.create :admin, email: "admin@gmail.com", approved: true
  user = FactoryGirl.create(:user, email: "applicant@gmail.com")
  employer = FactoryGirl.create(:employer, email: "employer@gmail.com", approved: true)
  puts "Create users"
  com = FactoryGirl.create(:company, user: employer)
  invite_code = FactoryGirl.create(:invite_code, user: employer)
  FactoryGirl.create(:manager, email: "manager@gmail.com", invite_code: invite_code.code)

  puts "Create company"
  profs = FactoryGirl.create_list :speciality, 4
  puts "Create professions"
  10.times.each do
    FactoryGirl.create :vacancy,
      company: com,
      speciality: profs[0]
  end

  10.times.each do
    FactoryGirl.create :vacancy,
    company: FactoryGirl.create(:company, user: FactoryGirl.create(:employer, approved: true)),
    speciality: profs[1]
  end

  10.times.each do
    FactoryGirl.create :vacancy,
    company: com,
    speciality: profs[2]
  end

  10.times.each do
    FactoryGirl.create :vacancy,
    company: FactoryGirl.create(:company, user: FactoryGirl.create(:employer,  approved: true)),
    speciality: profs[3]
  end

  10.times.each do
    FactoryGirl.create :archived_vacancy,
    company: com,
    speciality: profs[3]
  end

  puts "Create vacancies"
end

