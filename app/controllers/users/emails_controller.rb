class Users::EmailsController < ApplicationController

  authorize_resource :class => false
  load_resource :user, :parent => false

  def new_email
    respond_to do |format|
      format.js {render layout: false}
    end
  end
  def send_denial
    if current_user.send_denial_email(@user, params[:denial_email])
      redirect_to :back, notice: "Denial email was successfully sent"
    else
      redirect_to :back, alert: "Something is went wrong. Email is not sent"
    end
  end
end