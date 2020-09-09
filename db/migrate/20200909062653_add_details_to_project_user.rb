class AddDetailsToProjectUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :project_users, :user_id, :integer
  end
end
