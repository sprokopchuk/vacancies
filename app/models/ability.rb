class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    case
    when user.role?(:admin)
      can :access, :rails_admin
      can :dashboard
      can [:read, :create], :chart
      can [:read, :charts], Vacancy
      can :manage, Company
      can [:read, :toggle], User
    when user.role?(:employer)
      if user.approved?
        can [:read, :create], InviteCode, :user_id => user.id
        can [:read, :download_resume], User
        can [:new_email, :send_denial], :email
        can :update, Company, :user_id => user.id
        can [:close, :create], Vacancy, :company => {:user_id => user.id}
      end
    when user.role?(:manager)
      can [:read, :download_resume], User
      can [:new_email, :send_denial], :email
      can [:close, :create], Vacancy, :company => {:user_id => user.get_owner_of_invite_code.id}
    when user.role?(:applicant)
      can [:download_resume, :read], User, :id => user.id
      can :attach_resume, Vacancy
    end
    can :read, [Company, Vacancy]
  end
end
