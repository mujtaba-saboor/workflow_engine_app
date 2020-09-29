class Ability
  include CanCan::Ability

  def initialize(user)
    # :create abilities here are linked to the controllers. Heed precation editing them.
    # The fields set by abilities (:create) here are used by the respective actions in controllers
    # :manage includes :create so precaution should be taken editing these abilites
    # *** ALL USERS ***
    return if user.blank?

    # *** SIGNED IN USERS ***
    can :read, Team, sequence_num: user.teams.pluck(:sequence_num), company_id: user.company_id
    can :read, Project, sequence_num: user.all_projects.pluck(:sequence_num), company_id: user.company_id
    can :project_users, Project

    can :create, Comment, user_id: user.id, company_id: user.company_id
    can %i[update destroy], Comment, user_id: user.id, company_id: user.company_id, commentable: { company_id: user.company_id }

    can :read, Issue, company_id: user.company_id

    can :update_status, Issue, company_id: user.company_id, assignee_id: user.id

    can :create, Issue, company_id: user.company_id, creator_id: user.id

    can :read, User, sequence_num: user.sequence_num, company_id: user.company_id
    can :edit, User, sequence_num: user.sequence_num, company_id: user.company_id

    return unless user.admin? || user.account_owner?

    # *** ADMINS and OWNERS ***
    can :manage, :all, company_id: user.company_id
    cannot :destroy, User, role: User::ROLES[2]

    return unless user.account_owner?

    # *** OWNERS ***
    can :manage, :all, company_id: user.company_id
    can :read, Invite, company_id: user.company_id
    can :create, Invite, company_id: user.company_id
    can :edit, User, company_id: user.company_id
  end
end
