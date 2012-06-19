class AddMovieAttrToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :subtitle, :string
    add_column :movies, :actor, :string
    add_column :movies, :year, :string
    add_column :movies, :rating, :string
  end
end
