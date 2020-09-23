class Ability
  include CanCan::Ability

  def initialize(user)
    binding.pry
    @users = user.company.users
    if user
      can :manage, :all
    end
   
  end
end
