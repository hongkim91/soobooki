class AddDateToBookPosts < ActiveRecord::Migration
  def change
    add_column :book_posts, :year, :integer
    add_column :book_posts, :month, :integer
    add_column :book_posts, :day, :integer
  end
end
