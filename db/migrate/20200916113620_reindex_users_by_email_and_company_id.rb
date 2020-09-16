class ReindexUsersByEmailAndCompanyId < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, :email
    add_index :users, %i[email company_id], unique: true
  end
end
