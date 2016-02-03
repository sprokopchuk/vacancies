class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.employer?
      can :manage, Vacancy, :company => {:user_id => user.id}
      can :read, Vacancy
    else
      can :attach_resume, Vacancy if user.persisted?
      can :read, Vacancy
    end


  end
end
