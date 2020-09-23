class Ability
  include CanCan::Ability

  def initialize(user)
    binding.pry
    if user.role.eql?('OWNER') || user.role.eql?('ADMIN')
      can :manage, :all
    else
      can :read, User,  sequence_num: user.company.users.pluck(:id)
    end
  end
end
