class CompaniesController < ApplicationController

  load_and_authorize_resource
  def show
    @vacancies = @company.vacancies.page(params[:page])
  end

end