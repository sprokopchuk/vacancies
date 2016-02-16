require 'rails_helper'

RSpec.describe ChartForm, type: :model do

  let(:company) {FactoryGirl.create :company}
  let(:other_company) {FactoryGirl.create :company}
  let(:vacancies) {FactoryGirl.create_list :vacancy, 3, company: company}
  let(:other_vacancies) {FactoryGirl.create_list :vacancy, 3, company: other_company}
  let(:params) {{}}
  subject {ChartForm.new params: params}

  before do
    params["company"] = company.id
    params["from"] = Date.current.to_s
    params["to"] = Date.current.to_s
  end
  it "set default vacancies" do
    expect(subject.vacancies).to match_array vacancies
  end

  it "set default company if company is passed" do
    expect(subject.company).to eq company
  end

  it "set default date for @from if passed variable is date @from last year" do
    params["from"] = Date.current.prev_year.to_s
    params["to"] = Faker::Date.backward(14).to_s
    expect(subject.from).to eq(Date.current.beginning_of_year)
  end

  it "set default date for @from is passed variable is more than @to" do
    params["from"] = 1.days.ago.to_s
    params["to"] = 14.days.ago.to_s
    expect(subject.from).to eq(Date.current.beginning_of_year)
  end

  it "set default date for @from is passed variable is equal @to" do
    params["to"] = params["from"] = 14.days.ago.to_date.to_s
    expect(subject.from).to eq(Date.current.beginning_of_year)
  end

  it "set default date for @to if passed variable is date from last year" do
    params["to"] = Date.current.prev_year.to_s
    expect(subject.to).to eq(Date.current.end_of_year)
  end

  it "set default date for @to if passed variable is equal @from" do
    params["to"] = params["from"] = 14.days.ago.to_date.to_s
    expect(subject.to).to eq(Date.current.end_of_year)
  end

end