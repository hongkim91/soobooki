class BookPostsController < ApplicationController
  # GET /book_posts
  # GET /book_posts.json
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

  # GET /book_posts/1
  # GET /book_posts/1.json
  def show
    @book_post = BookPost.find(params[:id])
    @user = @book_post.user
    @book = Book.find(@book_post.book_id)
    @controller = params[:controller]
    @action = params[:action]

    if post_privacy_valid?
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @book_post }
      end
    end
  end

  # GET /book_posts/new
  # GET /book_posts/new.json
  def new
    @book_post = BookPost.new(year: Time.now.year, month: Time.now.month, day:Time.now.day)
    @controller = params[:controller]

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    #TODO: check if the book already exists.

    if params[:api].present?
      create_from_search and return
    end
    @book = Book.new(title: params[:book_post][:title], image: params[:book_post][:image],
                 remote_image_url: params[:book_post][:remote_image_url])
    @book_post = @book.book_posts.build(params[:book_post])
    @book_post.user = current_user

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book_post, notice: 'Book post was successfully created.' }
      else
        flash[:notice] = @book.errors.full_messages[0]
        format.html { render action: "new" }
      end
    end
  end

  def create_from_search
    if params[:api] == "daum"
      params.map do |key,value|
        params[key] = value.gsub('<b>','').gsub('</b>','') unless value.nil?
      end
      image_url = "http://book.daum-img.net/image/"+params[:api_id]
      unless remote_image_exists?(image_url)
        image_url = "http://book.daum-img.net/image/KOR"+params[:isbn13]
      end
    elsif params[:api] == "amazon"
      image_url = params[:cover_image_url]
    end

    @book = Book.new(title: params[:title], remote_image_url: image_url, authors: params[:authors],
                 translators: params[:translators], publisher: params[:publisher], category: params[:category],
                 pub_date: params[:pub_date], api_id: params[:api_id], isbn: params[:isbn], isbn13: params[:isbn13])
    @book.book_posts.build(user_id: current_user.id, year: Time.now.year, month: Time.now.month,
                     day: Time.now.day)
    @api_id = params[:api_id]
    respond_to do |format|
      if @book.save!
        format.js
      end
    end
  end

  # GET /book_posts/1/edit
  def edit
    @book_post = current_user.book_posts.find(params[:id])
    @book = Book.find(@book_post.book_id)
    @controller = params[:controller]
  end

  # PUT /book_posts/1
  # PUT /book_posts/1.json
  def update
    @book_post = current_user.book_posts.find(params[:id])
    review = params[:book_post][:review]
    params[:book_post][:review] = Sanitize.clean(review,Sanitize::Config::RELAXED)

    respond_to do |format|
      if @book_post.update_attributes(params[:book_post])
        format.html { redirect_to @book_post, notice: 'Book post was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /book_posts/1
  # DELETE /book_posts/1.json
  def destroy
    @book_post = current_user.book_posts.find(params[:id])
    @book_post.destroy

    respond_to do |format|
      format.html { redirect_to book_posts_url, notice: 'Book post was successfully deleted.'}
      format.json { head :no_content }
    end
  end

  def mercury_update
    book_post = current_user.book_posts.find(params[:id])
    book_post.review = Sanitize.clean(params[:content][:book_post_review][:value],
                                Sanitize::Config::RELAXED)
    book_post.save!
    render text: ""
  end

  def edit_privacy
    @book_post = BookPost.find(params[:id])
    @book_post.privacy = params[:privacy]
    @book_post.save
    respond_to do |format|
      format.js
    end
  end
end


