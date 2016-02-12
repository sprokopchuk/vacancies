class InviteCodesController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def create
    @invite_code.code = current_user.generate_invite_code
    @invite_code.user_id = current_user.id
    if @invite_code.save
      redirect_to :back, :notice => "Invite code was generated successfully"
    else
      redirect_to :back, :alert => "Something is wrong. Invite code was not generated"
    end
  end

end
