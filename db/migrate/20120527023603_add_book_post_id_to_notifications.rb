class AddBookPostIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :book_post_id, :integer
  end
end
