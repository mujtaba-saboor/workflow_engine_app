class RenameTypeColumnInIssuesTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :issues, :type, :issue_type
  end
end
