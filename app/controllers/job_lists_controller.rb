class JobListsController < ApplicationController

  before_action :authenticate_user!
  before_action :specialities

  def show
    @job_list = current_user.vacancies.page(params[:page])
  end

  private
  def specialities
    @specialities = Speciality.all
  end
end