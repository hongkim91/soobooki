module BookPostsHelper
  def find_book(id)
    Book.find(id)
  end
  def is_park
    if @user.email == "park@park.com" ||
        @user.email == "mwkim226@gmail.com" ||
        @user.email == "han.lee0707@gmail.com"
      return true
    end
#    return true
  end
end
