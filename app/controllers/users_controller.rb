class UsersController < ApplicationController

  load_and_authorize_resource

  def download_resume
    if @user.resume.file
      if resume_not_viewed? params[:vacancy_id]
        @user.toggle_viewed params[:vacancy_id]
      end
      data = open(@user.resume.url)
      send_data data.read,
                filename: @user.resume.filename,
                type: @user.resume.content_type
    else
      redirect_to @user, notice: "User's resume is missing"
    end
  end

  def show
  end

  private

  def resume_not_viewed? vacancy_id
     !@user.resume_viewed?(vacancy_id) && (current_user.role?(:employer) || current_user.role?(:manager))
  end

end