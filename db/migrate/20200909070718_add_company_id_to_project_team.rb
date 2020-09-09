class AddCompanyIdToProjectTeam < ActiveRecord::Migration[6.0]
  def change
    add_reference :project_teams, :company, null: false, foreign_key: true
  end
end
