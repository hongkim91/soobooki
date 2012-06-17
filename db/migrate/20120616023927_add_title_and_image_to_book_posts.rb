class AddTitleAndImageToBookPosts < ActiveRecord::Migration
  def change
    add_column :book_posts, :title, :string
    add_column :book_posts, :image, :string
  end
end
