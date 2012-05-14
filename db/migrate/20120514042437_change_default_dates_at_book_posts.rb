class ChangeDefaultDatesAtBookPosts < ActiveRecord::Migration
  def up
    change_column_default(:book_posts, :year, 0)
    change_column_default(:book_posts, :month, 0)
    change_column_default(:book_posts, :day, 0)
  end
end
