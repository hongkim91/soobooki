class AddPrivacyToBookPosts < ActiveRecord::Migration
  def change
    add_column :book_posts, :privacy, :string
    change_column_default :book_posts, :privacy, "Friends"
  end
end
