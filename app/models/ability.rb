class Ability
  include CanCan::Ability

  def initialize(user)
    # :create abilities here are linked to the controllers. Heed precation editing them.
    # The fields set by abilities (:create) here are used by the respective actions in controllers
    # :manage includes :create so precaution should be taken editing these abilites
    # *** ALL USERS ***
    return if user.blank?

    # *** SIGNED IN USERS ***
    can :read, Team, id: user.teams.pluck(:id)
    can :read, Project,  id: user.all_projects.pluck(:id)
    can :project_users, Project

    can :create, Comment, user_id: user.id, company_id: user.company_id
    can %i[update destroy], Comment, user_id: user.id, company_id: user.company_id, commentable: { company_id: user.company_id }

    can :read, Issue, company_id: user.company_id

    can :update_status, Issue, company_id: user.company_id, assignee_id: user.id

    can :create, Issue, company_id: user.company_id, creator_id: user.id

    can :watch_issue, Issue, company_id: user.company_id

    can :create, Watcher, company_id: user.company_id, user_id: user.id

    return unless user.admin? || user.account_owner?

    # *** ADMINS and OWNERS ***
    can :manage, :all, company_id: user.company_id
    cannot :destroy, User, role: User::ROLES[2]

    return unless user.account_owner?

    # *** OWNERS ***
    can :manage, :all, company_id: user.company_id
  end
end
