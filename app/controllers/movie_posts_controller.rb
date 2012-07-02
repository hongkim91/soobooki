class MoviePostsController < ApplicationController
  def index
    if params.has_key?(:id)
      @user = find_user(params[:id])
      redirect_to log_in_path,
      notice: "Couldn't find the user with id: "+params[:id] and return if @user.nil?
    else
      @user = logged_in? # sets @user to current_user
      return if @user.nil?
    end
    if itemshelf_privacy_valid?
      posts_index
    end
  end

  def show
    @movie_post = MoviePost.find(params[:id])
    @user = @movie_post.user
    @movie = Movie.find(@movie_post.movie_id)

    if post_privacy_valid?
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end

  def new
    @movie_post = MoviePost.new(year: Time.now.year, month: Time.now.month, day:Time.now.day)
    @controller = params[:controller]

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    if params[:api].present?
      create_from_search and return
    end
    @movie = Movie.new(title: params[:movie_post][:title], image: params[:movie_post][:image],
                remote_image_url: params[:movie_post][:remote_image_url])
    @movie_post = @movie.movie_posts.build(params[:movie_post])
    @movie_post.user = current_user

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie_post, notice: 'Movie post was successfully created.' }
      else
        flash[:notice] = @movie.errors.full_messages[0]
        format.html { render action: "new" }
      end
    end
  end

  def create_from_search
    if params[:api] == "naver"
      image_url = params[:image_url].gsub("mit110","mi")
    elsif params[:api] == "tomato"
      image_url = params[:image_url].gsub("_mob","_ori")
    end

    @movie = Movie.new(title: params[:title], subtitle: params[:subtitle], remote_image_url: image_url,
                   director: params[:director], actor: params[:actor], year: params[:year],
                   rating: params[:rating])
    @movie.movie_posts.build(user_id: current_user.id, year: Time.now.year, month: Time.now.month,
                     day: Time.now.day)
    respond_to do |format|
      if @movie.save!
        format.js
      end
    end
  end

  def edit
    @movie_post = current_user.movie_posts.find(params[:id])
    @movie = Movie.find(@movie_post.movie_id)
    @controller = params[:controller]
  end

  def update
    @movie_post = current_user.movie_posts.find(params[:id])
    params[:movie_post][:review] =
      Sanitize.clean(params[:movie_post][:review],Sanitize::Config::RELAXED)

    respond_to do |format|
      if @movie_post.update_attributes(params[:movie_post])
        format.html { redirect_to @movie_post, notice: 'Movie post was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @movie_post = current_user.movie_posts.find(params[:id])
    @movie_post.destroy

    respond_to do |format|
      format.html { redirect_to movie_posts_url, notice: 'Movie post was successfully deleted.'}
    end
  end

  def mercury_update
    movie_post = current_user.movie_posts.find(params[:id])
    movie_post.review = Sanitize.clean(params[:content][:movie_post_review][:value],
                                Sanitize::Config::RELAXED)
    movie_post.save!
    render text: ""
  end

  def edit_privacy
    @movie_post = MoviePost.find(params[:id])
    @movie_post.privacy = params[:privacy]
    @movie_post.save
    respond_to do |format|
      format.js
    end
  end
end
