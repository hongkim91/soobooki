class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :bookshelf
  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def bookshelf(user)
    if user.nil?
      book_posts_path
    elsif user.username.blank?
      bookshelf_path(:id => user.id)
    else
      bookshelf_path(:id => user.username)
    end
  end
end
