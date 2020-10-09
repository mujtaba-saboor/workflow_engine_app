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
    can [:read,:filters], Project, sequence_num: user.all_projects.pluck(:sequence_num), company_id: user.company_id
    can :project_users, Project

    can :create, Comment, user_id: user.id, company_id: user.company_id
    can %i[update destroy], Comment, user_id: user.id, company_id: user.company_id, commentable: { company_id: user.company_id }

    can %i[read all filter], Issue, company_id: user.company_id, project: { sequence_num: user.all_projects.pluck(:sequence_num) }

    can :update_status, Issue, company_id: user.company_id, assignee_id: user.id

    can :watch_issue, Issue, company_id: user.company_id, project: { id: user.all_projects.pluck(:id) }

    can :create, Watcher, company_id: user.company_id, user_id: user.id, issue: { project: {  id: user.all_projects.pluck(:id) } }
    can :destroy, Watcher, company_id: user.company_id, user_id: user.id

    can :edit, User, sequence_num: user.sequence_num, company_id: user.company_id
    can :update, User, sequence_num: user.sequence_num, company_id: user.company_id

    can [:read, :filter], User, company_id: user.company_id

    return unless user.admin? || user.account_owner?

    # *** ADMINS and OWNERS ***
    can :create, Issue, company_id: user.company_id, creator_id: user.id

    can :manage, :all, company_id: user.company_id
    can :destroy, User, company_id: user.company_id, role: User::ROLES[0]
    cannot :destroy, User, company_id: user.company_id, role: User::ROLES[2]
    cannot :destroy, User, company_id: user.company_id, role: User::ROLES[1]

    cannot :update, User, role: User::ROLES[2]
    cannot :make_owner_page, User
    return unless user.account_owner?

    # *** OWNERS ***
    can :manage, :all, company_id: user.company_id
    can :read, Invite, company_id: user.company_id
    can :create, Invite, company_id: user.company_id
    can :edit, User, company_id: user.company_id
    can :update, User, company_id: user.company_id
    can :read, User, company_id: user.company_id
    can :destroy, User, company_id: user.company_id
    can :destroy, User, company_id: user.company_id, role: User::ROLES[1]
    cannot :destroy, User, company_id: user.company_id, role: User::ROLES[2]
    can :make_owner_page, User, company_id: user.company_id
  end
end
