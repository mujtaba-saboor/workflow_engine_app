class AddColumnToTeamUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_users, :user_id, :integer
  end
end
