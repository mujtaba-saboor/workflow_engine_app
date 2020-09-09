class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :commentable, polymorphic: true, index: true
      t.references :users, null: false, index: true
      t.references :companies, null: false, index: true
      t.timestamps
    end
  end
end
