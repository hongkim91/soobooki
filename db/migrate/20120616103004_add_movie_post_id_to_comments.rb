class AddMoviePostIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :movie_post_id, :integer
  end
end
