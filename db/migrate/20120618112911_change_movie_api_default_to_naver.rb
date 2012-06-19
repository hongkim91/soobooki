class ChangeMovieApiDefaultToNaver < ActiveRecord::Migration
  def change
    change_column_default :users, :movie_api, "naver"
  end
end
