class CreateProjectTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :project_teams do |t|
      t.belongs_to :project
      t.belongs_to :team

      t.timestamps
    end
  end
end
