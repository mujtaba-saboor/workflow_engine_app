class CreateTeamUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_users do |t|
      t.belongs_to :team, null: false, index: true
      t.belongs_to :company, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.timestamps
    end
  end
end
