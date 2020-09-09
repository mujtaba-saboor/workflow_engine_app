class AddUserToTeamUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :team_users, :user, null: false, foreign_key: true
  end
end
