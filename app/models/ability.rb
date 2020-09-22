class Ability
  include CanCan::Ability

  def initialize(user)

    if user.role.eql? User::ROLES[2]
      can :manage, :all
    elsif user.role.eql? User::ROLES[0]
      can :read, Team, id: user.teams.pluck(:id) 
      can :read, Project,  id: user.all_projects.pluck(:id) 
      can :project_users, Project
    elsif user.role.eql? User::ROLES[1]
      can :manage, :all
      cannot :destroy, User, role: User::ROLES[2]
    end
  end
end
