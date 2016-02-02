require 'rails_helper'

RSpec.describe VacancySearch, type: :model do

  let(:opened_vacancies) {FactoryGirl.create_list :vacancy, 3}
  let(:params) {{}}
  subject{VacancySearch.new(Vacancy.all)}
  context "#call" do
    before do
      opened_vacancies
    end

    it "return the list of vacancies by default" do
      expect(subject.call).to match_array(opened_vacancies)
    end

    it "return the list of vacancies if params[:search][:country] is passed" do
      opened_vacancies[0].country = 'Uk'
      params[:country] = 'Uk'
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(Vacancy.where(:country => params[:country]))
    end

    it "return the list of vacancies if params[:search][:city] is passed" do
      opened_vacancies[0].city = 'Dnepr'
      params[:city] = 'Dnepr'
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(Vacancy.where(:city => params[:city]))
    end

    it "return the list of vacancies if params[:search][:company_id] is passed" do
      opened_vacancies[0].company_id = 1
      params[:company_id] = 1
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(Vacancy.where(:company_id => params[:company_id]))
    end

    it "return the list of vacancies if params[:search][:speciality_id] is passed" do
      opened_vacancies[0].speciality_id = 1
      params[:speciality_id] = 1
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(Vacancy.where(:speciality_id => params[:speciality_id]))
    end
  end
end