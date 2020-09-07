class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description

      t.integer :type # enum: bug or issue
      t.integer :priority # enum: low or high
      t.integer :status # enum: open, in_progress, resolved or closed

      t.timestamps
    end
  end
end
