class CreateBookPosts < ActiveRecord::Migration
  def change
    create_table :book_posts do |t|
      t.integer :user_id
      t.integer :book_id
      t.text :review

      t.timestamps
    end
  end
end
