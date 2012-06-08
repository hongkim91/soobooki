class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :bookshelf, :user_name, :find_user

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def find_user(id)
    User.find_by_id(id)
  end

  def user_name(user)
    if user.first_name?
      if  user.last_name?
        return user.first_name+" "+user.last_name
      else
        return user.first_name
      end
    elsif user.bookshelf_name?
      return user.bookshelf_name
    else
      return user.email
    end
  end

  def bookshelf(user)
    if user.nil?
      book_posts_path
    elsif user.bookshelf_name.blank?
      bookshelf_path(:id => user.id)
    else
      bookshelf_path(:id => user.bookshelf_name)
    end
  end

  def remote_image_exists?(image_url)
    begin
      url = URI.parse(image_url)
      if url.respond_to?(:request_uri)
        Net::HTTP.start(url.host, url.port) do |http|
          return http.head(url.request_uri)['Content-Type'].starts_with? 'image'
        end
      end
      return false
    rescue
      return false
    end
  end

  def logged_in?
    if current_user.present?
      @user = current_user
    else
      unless params[:controller] == "sessions" and params[:action] == "new"
        redirect_to log_in_path, notice: "Please log in first." and return
      end
    end
  end
end
