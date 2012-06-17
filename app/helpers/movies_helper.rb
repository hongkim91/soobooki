module MoviesHelper
  def find_movie(id)
    @movie = Movie.find_by_id(id)
  end
end
