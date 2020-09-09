class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name,   null: false, default: ""
      t.string :domain, null: true, default: ""
      t.timestamps
    end

  end
end
