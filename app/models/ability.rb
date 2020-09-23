class Ability
  include CanCan::Ability

  def initialize(user)

    if user.owner?
      can :manage, :all
    elsif user.staff?
      can :read, Team, id: user.teams.pluck(:id)
      can :read, Project,  id: user.all_projects.pluck(:id)
      can :project_users, Project
    elsif user.admin?
      can :manage, :all
      cannot :destroy, User, role: User::ROLES[2]
    end
  end
end
