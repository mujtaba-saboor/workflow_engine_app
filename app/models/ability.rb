class Ability
  include CanCan::Ability

  def initialize(user)
    binding.pry
    if user
      can :manage, :all
    end
   
  end
end
