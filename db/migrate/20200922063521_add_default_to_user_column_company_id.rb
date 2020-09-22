class AddDefaultToUserColumnCompanyId < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :company_id, 1
  end
end
