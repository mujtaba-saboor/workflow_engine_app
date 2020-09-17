class Ability
  include CanCan::Ability

  def initialize(user)
    # :create abilities here are linked to the controllers. Heed precation editing them.
    # The fields set by abilities (:create) here are used by the respective actions in controllers
    # :manage includes :create so precaution should be taken editing these abilites
    return if user.blank?

    can :create, Comment, user_id: user.id, company_id: user.company_id
    can %i[update destroy], Comment, user_id: user.id, company_id: user.company_id, commentable: { company_id: user.company_id }

    can :read, Project, company_id: user.company_id

    can :read, Issue, company_id: user.company_id

    can :create, Issue, company_id: user.company_id
    can :create, Issue, creator_id: user.id

    can :destroy, Issue, creator_id: user.id, company_id: user.company_id
    can :update, Issue do |issue|
      (issue.assignee_id == user.id || issue.creator_id == user.id) && issue.company_id == user.company_id
    end
    # can :change_assignee, Issue do |issue|
    #   issue.creator_id == user.id || issue.assignee_id != user.id
    # end
  end
end
