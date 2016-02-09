class Companies::BuildController < ApplicationController

  include Wicked::Wizard
  steps :add_country, :add_city, :add_info
  before_action :set_company

  def show
    render_wizard
  end

  def update
    params[:company][:status] = step.to_s
    params[:company][:status] = 'active' if step == steps.last
    @company.update(company_params)
    render_wizard @company
  end

  private
  def finish_wizard_path
    flash[:notice] = "Your company registered. After approving your account administrator you can sign in and post vacancies!"
    super
  end

  def company_params
    params.require(:company).permit(:name, :country, :city, :description, :url, :state, :status)
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

end
