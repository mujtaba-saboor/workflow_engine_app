module TeamsHelper
  def is_member_available?(team)
    User.where.not(id: team.users.select(:id)).to_a.empty?
  end
  def team_users(team)
    User.where.not(id: team.users.select(:id))
  end
end
