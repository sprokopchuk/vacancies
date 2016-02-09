class CompaniesController < ApplicationController

  load_and_authorize_resource
  before_action :vacancies
  def show
  end

  private

  def vacancies
    @vacancies = @company.vacancies.page(params[:page])
  end

end