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

    can :update_status, Issue, company_id: user.company_id, assignee_id: user.id

    can :create, Issue, company_id: user.company_id, creator_id: user.id

    return unless user.role == 'ADMIN' || user.role == 'CREATOR'

    can :update_status, Issue, company_id: user.company_id
    can :destroy, Issue, company_id: user.company_id
    can :update, Issue, company_id: user.company_id
  end
end
