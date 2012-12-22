class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :bookshelf, :movieshelf, :user_name, :find_user

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def find_user(id)
    id = id.to_s
    if id =~ /[0-9]+/
      User.find_by_id(id)
    else
      User.find_by_soobooki_id!(id)
    end
  end

  def user_name(user)
    if user.first_name?
      if user.last_name?
        return user.first_name+" "+user.last_name
      else
        return user.first_name
      end
    elsif user.soobooki_id?
      return user.soobooki_id
    else
      return user.email
    end
  end

  def bookshelf(user)
    if user.nil?
      book_posts_path
    elsif user.soobooki_id.blank?
      bookshelf_path(:id => user.id)
    else
      bookshelf_path(:id => user.soobooki_id)
    end
  end

  def movieshelf(user)
    if user.nil?
      movie_posts_path
    elsif user.soobooki_id.blank?
      movieshelf_path(:id => user.id)
    else
      movieshelf_path(:id => user.soobooki_id)
    end
  end

  def remote_image_exists?(image_url)
    begin
      url = URI.parse(image_url)
      if url.respond_to?(:request_uri)
        return HTTParty.get(url.to_s).headers['content-type'].starts_with? 'image'
      else
        return false
      end
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

  def itemshelf_privacy_valid?
    if params[:controller] == "book_posts"
      itemshelf_privacy = @user.bookshelf_privacy
      itemshelf_path = bookshelf(current_user)
      itemshelf = "bookshelf"
    else
      itemshelf_privacy = @user.movieshelf_privacy
      itemshelf_path = movieshelf(current_user)
      itemshelf = "movieshelf"
    end
    if itemshelf_privacy == "Only Me"
      unless current_user == @user
        redirect_to itemshelf_path,
        notice: "#{user_name(@user)}'s "+itemshelf+" is private." and return false
      end
    elsif itemshelf_privacy == "Friends"
      msg = "#{user_name(@user)}'s "+itemshelf+" is only open to friends."
      unless current_user.present?
        redirect_to log_in_path, notice: msg+" Please log in first!" and return false
      end
      unless current_user == @user or @user.friends.include?(current_user)
        redirect_to friendships_path,
        notice: msg+" Send a friend request!" and return false
      end
    elsif itemshelf_privacy == "Users"
      unless current_user.present?
        redirect_to log_in_path,
        notice: "You must first log in to view #{user_name(@user)}'s "+itemshelf+"." and return false
      end
    end
    return true
  end

  def post_privacy_valid?
    if params[:controller] == "book_posts"
      post_privacy = @book_post.privacy
      itemshelf_path = bookshelf(@user)
      item = "book"
      title = @book_post.title
    else
      post_privacy = @movie_post.privacy
      itemshelf_path = movieshelf(@user)
      item = "movie"
      title = @movie_post.title
    end
    if post_privacy == "Only Me"
      unless current_user == @user
        redirect_to itemshelf_path,
        notice: "#{user_name(@user)}'s book review on '"+title+"' is private." and return false
      end
    elsif post_privacy == "Friends"
      unless current_user == @user or @user.friends.include?(current_user)
        redirect_to itemshelf_path,
        notice: "#{user_name(@user)}'s book review on"+
          " '"+title+"' is only open to friends. Send a friend request!" and return false
      end
    elsif post_privacy == "Users"
      unless current_user.present?
        redirect_to itemshelf_path,
        notice: "You must first log in to view #{user_name(@user)}'s"+
          " book review on '"+title+"'." and return false
      end
    end
    return true
  end

  def posts_index
    increment_size = 10
    previous_post = nil
    @controller = params[:controller]
    if @controller == "book_posts"
      user_posts = @user.book_posts
    elsif @controller == "movie_posts"
      user_posts = @user.movie_posts
    else
      return render text: "post_index: unrecognized controller, couldn't determine user_posts"
    end

    if params[:next_index]
      posts = user_posts.order("year DESC","month DESC","day DESC","created_at DESC")
        .limit(increment_size).offset(params[:next_index])
      @next_index = increment_size + params[:next_index].to_i
      previous_post = user_posts.order("year DESC","month DESC","day DESC","created_at DESC")
        .limit(1).offset(params[:next_index].to_i-1).first
    else
      posts = user_posts.order("year DESC","month DESC","day DESC","created_at DESC")
        .limit(increment_size)
      @next_index = increment_size
    end
    @posts_size = user_posts.size

    @posts_by_year_and_month = {}
    posts.each do |post|
      if !@posts_by_year_and_month.include?(post.year)
        @posts_by_year_and_month[post.year] = {post.month => [post]}
      elsif !@posts_by_year_and_month[post.year].include?(post.month)
        @posts_by_year_and_month[post.year][post.month] = [post]
      else
        @posts_by_year_and_month[post.year][post.month] << post
      end
    end

    unless @posts_by_year_and_month.empty?
      max_year = @posts_by_year_and_month.keys().max
      max_month = @posts_by_year_and_month[max_year].keys().max

      if previous_post && (previous_post.year == max_year) &&
          (previous_post.month == max_month)
        @last_month_posts = @posts_by_year_and_month[max_year].delete(max_month)
        if @posts_by_year_and_month[max_year].empty?
          @posts_by_year_and_month.delete(max_year)
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
end
