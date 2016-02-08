require 'rails_helper'

RSpec.describe VacancySearch, type: :model do

  let(:company) {FactoryGirl.create :company}
  let(:opened_vacancies) {FactoryGirl.create_list :vacancy, 3, company: company}
  let(:params) {{}}
  context "#call" do
    before do
      opened_vacancies
    end

    it "return the list of vacancies by default" do
      expect(VacancySearch.new(params: {}).call).to match_array(opened_vacancies)
    end

    it "return the list of vacancies if params[:search][:country] is passed" do
      opened_vacancies[0].country = 'Uk'
      opened_vacancies[0].save!
      params[:country] = "Uk"
      expect(
        VacancySearch.new(params: params).call
        ).to match_array(Vacancy.where(params))
    end

    it "return the list of vacancies if params[:search][:city] is passed" do
      opened_vacancies[0].city = 'Dnepr'
      opened_vacancies[0].save!
      params[:city] = "Dnepr"
      expect(
        VacancySearch.new(params: params).call
        ).to match_array(Vacancy.where(:city => params[:city]))
    end

    it "return the list of vacancies if params[:search][:company_id] is passed" do
      params[:company_id] = company.id
      expect(
        VacancySearch.new(params: params).call
        ).to match_array(Vacancy.where(:company_id => params[:company_id]))
    end

    it "return the list of vacancies if params[:search][:speciality_id] is passed" do
      opened_vacancies[0].speciality_id = 1
      params[:speciality_id] = 1
      expect(
        VacancySearch.new(params: params).call
        ).to match_array(Vacancy.where(params))
    end
  end
end