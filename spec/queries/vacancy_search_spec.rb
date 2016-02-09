require 'rails_helper'

RSpec.describe VacancySearch, type: :model do

  let(:company) {FactoryGirl.create :company}
  let(:opened_vacancies) {FactoryGirl.create_list :vacancy, 3, company: company}
  let(:searched_vacancy) {FactoryGirl.create :vacancy}
  let(:params) {{}}
  context "#call" do

    before do
      opened_vacancies
      searched_vacancy
    end
    it "return the list of vacancies by default" do
      expect(VacancySearch.new(params: {}).call).to match_array(opened_vacancies << searched_vacancy)
    end

    it "return the list of vacancies if params[:country] is passed" do
      params["country"] = searched_vacancy.country
      expect(
        VacancySearch.new(params: params).call
        ).to match_array([searched_vacancy])
    end

    it "return the list of vacancies if params[:city] is passed" do
      params["city"] = searched_vacancy.city
      expect(
        VacancySearch.new(params: params).call
        ).to match_array([searched_vacancy])
    end

    it "return the list of vacancies if params[:speciality_id] is passed" do
      params["speciality_id"] = searched_vacancy.speciality_id
      expect(
        VacancySearch.new(params: params).call
        ).to match_array([searched_vacancy])
    end

    context "by search" do
      it "return list of vacancies if params[:search] is set a as few characters of city" do
        params["search"] = searched_vacancy.city
        params["search"].slice! 0
        expect(
          VacancySearch.new(params: params).call
          ).to match_array([searched_vacancy])
      end

      it "return list of vacancies if params[:search] is set a as few characters of company's name" do
        params["search"] = searched_vacancy.company.name
        params["search"].slice! 0
        expect(
          VacancySearch.new(params: params).call
          ).to match_array([searched_vacancy])
      end

      it "return list of vacancies if params[:search] is set a as few characters of speciality" do
        params["search"] = searched_vacancy.speciality.name
        params["search"].slice! 0
        expect(
          VacancySearch.new(params: params).call
          ).to match_array([searched_vacancy])
      end


    end
  end
end