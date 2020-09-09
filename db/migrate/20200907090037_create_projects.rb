class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :project_category
      t.belongs_to :company, null: false, index: true

      t.timestamps
    end
  end
end
