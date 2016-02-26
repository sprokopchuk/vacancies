class JobListsController < ApplicationController

  before_action :authenticate_user!

  def show
    specialities
    @job_list = current_user.vacancies.page(params[:page])
  end

  private
  def specialities
    @specialities = Speciality.all
  end
end