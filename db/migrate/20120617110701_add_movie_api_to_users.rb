class AddMovieApiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :movie_api, :string, default: "daum"
    add_column :users, :search_target, :string, default: "books"
  end
end
