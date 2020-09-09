class AddCompanyIdToProject < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :company, null: false, foreign_key: true
  end
end
