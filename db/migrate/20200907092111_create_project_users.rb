class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.belongs_to :project, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.belongs_to :company, null: false, index: true

      t.timestamps
    end
  end
end
