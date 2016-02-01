class JobListsController < ApplicationController

  before_action :authenticate_user!

  def show
    @job_list = current_user.vacancies
  end
end