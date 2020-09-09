class RemoveUserIdFromTeamUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :team_users, :user_id, :integer
  end
end