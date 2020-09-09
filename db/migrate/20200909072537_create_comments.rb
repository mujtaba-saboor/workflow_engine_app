class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.references :users, index: true
      t.text :body, null: false

      t.references :companies, index: true
      t.timestamps
    end
  end
end
