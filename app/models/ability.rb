class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :create, Comment
    can :manage, Comment, user_id: user.id, company_id: user.company_id

    can :read, Project, company_id: user.company_id

    can :read, Issue, company_id: user.company_id
    can :create, Issue, company_id: user.company_id
    can :destroy, Issue, creator_id: user.id, company_id: user.company_id
    can :update, Issue do |issue|
      (issue.assignee_id == user.id || issue.creator_id == user.id) && issue.company_id == user.company_id
    end
    can :change_assignee, Issue do |issue|
      issue.creator_id == user.id || issue.assignee_id != user.id
    end
  end
end
