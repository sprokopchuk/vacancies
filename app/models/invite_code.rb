class InviteCode < ActiveRecord::Base
  belongs_to :user

  def get_user_used_invite
    User.where(:invite_code => self.code).take
  end
end
