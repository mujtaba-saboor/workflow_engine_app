class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
