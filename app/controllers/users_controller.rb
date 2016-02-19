class UsersController < ApplicationController

  load_and_authorize_resource

  def download_resume
    if @user.resume.file
      if (current_user.role?(:employer) || current_user.role?(:manager)) &&
        !@user.resume_viewed?(params[:vacancy_id])
        @user.toggle_viewed params[:vacancy_id]
      end
      data = open(@user.resume.url)
      send_data data.read,
                filename: @user.resume.filename,
                type: @user.resume.content_type,
                disposition: 'inline',
                stream: 'true',
                buffer_size: '4096'
    else
      redirect_to @user, notice: "User's resume is missing"
    end
  end

  def show
  end

end