class AddMoviePostIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :movie_post_id, :integer
  end
end
