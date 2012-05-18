class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.references :user
      t.references :book_post

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :book_post_id
  end
end
