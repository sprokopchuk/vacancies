class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.role? :employer
      if user.approved?
        can [:read, :download_resume], User
        can [:create, :update, :destroy], Company, :user_id => user.id
        can [:create, :update, :destroy], Vacancy, :company => {:user_id => user.id}
      end
    elsif user.role? :applicant
      can [:download_resume, :read], User, :id => user.id
      can :attach_resume, Vacancy
    end
    can :read, [Company, Vacancy]
  end
end
