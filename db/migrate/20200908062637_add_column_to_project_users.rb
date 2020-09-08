class AddColumnToProjectUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :project_users, :user_id, :integer
  end
end
