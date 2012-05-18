class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :bookshelf, :current_user_name
  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user_name
    if current_user.first_name?
      if  current_user.last_name?
        return current_user.first_name+" "+current_user.last_name
      else
        return current_user.first_name
      end
    end
    return ""
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
