class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :title, null: false
      t.text :description

      t.integer :issue_type, null: false # enum: bug or issue
      t.integer :priority, null: false # enum: low or high
      t.integer :status, null: false # enum: open, in_progress, resolved or closed

      t.references :creator, index: true
      t.references :assignee, null: true, index: true

      t.references :companies, index: true

      t.timestamps
    end
  end
end
