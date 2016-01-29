require 'rails_helper'

RSpec.describe VacancySearch, type: :model do

  let(:opened_vacancies) {FactoryGirl.create_list :vacancy, 3}
  let(:params) {{search: {}}}
  subject{VacancySearch.new(opened_vacancies)}
  context "#call" do
    it "return the list of vacancies by default" do
      expect(subject.call).to match_array(opened_vacancies)
    end

    it "return the list of vacancies if params[:search][:country] is passed" do
      opened_vacancies[0].country = 'Uk'
      params[:search][:country] = 'Uk'
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array([opened_vacancies[0]])
    end

    it "return the list of vacancies if params[:search][:city] is passed" do
      opened_vacancies[0].city = 'Dnepr'
      params[:search][:city] = 'Dnepr'
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(opened_vacancies[0])
    end

    it "return the list of vacancies if params[:search][:company_id] is passed" do
      opened_vacancies[0].company_id = 1
      params[:search][:company_id] = 1
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(opened_vacancies[0])
    end

    it "return the list of vacancies if params[:search][:speciality_id] is passed" do
      opened_vacancies[0].speciality_id = 1
      params[:search][:speciality_id] = 1
      subject.instance_variable_set(:@params, params)
      expect(subject.call).to match_array(opened_vacancies[0])
    end
  end
end