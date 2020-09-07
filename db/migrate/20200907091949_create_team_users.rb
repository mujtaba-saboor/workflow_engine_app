class CreateTeamUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_users do |t|
      t.belongs_to :team
      t.timestamps
    end
  end
end
