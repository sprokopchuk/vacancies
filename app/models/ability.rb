class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.role? :employer
      can :manage, Company, :user_id => user.id
      can :manage, Vacancy, :company => {:user_id => user.id} if user.approved?
      can :read, Vacancy
    else
      can :attach_resume, Vacancy if user.persisted?
      can :read, Vacancy
    end


  end
end
