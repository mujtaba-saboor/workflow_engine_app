class Ability
  include CanCan::Ability

  def initialize(user)

    if user.role.eql? 'OWNER'
      can :manage, :all
    elsif user.role.eql? 'STAFF'
      can :read, Team, id: user.teams.pluck(:id)
      can :read, Project, id: user.projects.pluck(:id)
      can :project_users, Project
    end
   
  end
end

#Owner and Admin can do any thing but admin can't remove OWNER
#Staff can't create,update,delete any project
#staff can't add,remove members/teams to project
#staff can only read project and see its issues
#staff can't add issues to project

#Staff can't create,update,delete any team
#staff can only read team and see its members
#staff can't add member to teams
