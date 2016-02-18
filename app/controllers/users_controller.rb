class UsersController < ApplicationController

  load_and_authorize_resource

  def download_resume
    if @user.resume.file
      if (current_user.role?(:employer) || current_user.role?(:manager)) &&
        !@user.resume_viewed?(params[:vacancy_id])
        @user.toggle_viewed params[:vacancy_id]
      end
      send_file @user.resume.file.path,
        filename: @user.resume.file.identifier,
        type: @user.resume.file.content_type
    else
      redirect_to @user, notice: "User's resume is missing"
    end
  end

  def show
  end

end