class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.role? :employer
      if user.approved?
        can [:create, :update, :destroy], Company, :user_id => user.id
        can [:create, :update, :destroy], Vacancy, :company => {:user_id => user.id}
     end
      can :read, Company
      can :read, Vacancy
    else
      can :read, Company
      can :attach_resume, Vacancy if user.persisted?
      can :read, Vacancy
    end


  end
end
