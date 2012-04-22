module BookPostsHelper
  def find_book(id)
    Book.find(id)
  end
end
