class AddCompanyIdToTeamUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :team_users, :company, null: false, foreign_key: true
  end
end
