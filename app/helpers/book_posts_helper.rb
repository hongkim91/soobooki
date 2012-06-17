module BookPostsHelper
  def find_book(id)
    @book = Book.find_by_id(id)
  end
end
