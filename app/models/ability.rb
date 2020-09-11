class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :create, Comment
      can :manage, Comment, user_id: user.id
      can :read, :all, company_id: user.company_id
      can :manage, Issue, creator_id: user.id
    end
  end
end
