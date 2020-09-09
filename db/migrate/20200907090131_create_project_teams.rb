class CreateProjectTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :project_teams do |t|
      t.belongs_to :project, null: false, index: true
      t.belongs_to :team, null: false, index: true
      t.belongs_to :company, null: false, index: true

      t.timestamps
    end
  end
end
