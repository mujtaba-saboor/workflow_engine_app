class Ability
  include CanCan::Ability

  def initialize(user)

    if user.role.eql? 'OWNER'
      can :manage, :all
    elsif user.role.eql? 'STAFF'
      can :read, Team, id: user.teams.pluck(:id)
      can :read, Project, id: user.projects.pluck(:id)
      can :project_users, Project
    elsif user.role.eql? 'ADMIN'
      can :manage, :all
      cannot :destroy, User, role: 'OWNER'
    end
   
  end
end
