class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.belongs_to :project

      t.timestamps
    end
  end
end
