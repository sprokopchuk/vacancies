class CompaniesController < ApplicationController

  load_and_authorize_resource
  def show
    @vacancies = @company.vacancies.page(params[:page])
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: "Information about company was successfully updated"
    else
      render :edit
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, :description, :country, :state, :city, :url, :status)
  end
end