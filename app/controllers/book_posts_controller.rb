class BookPostsController < ApplicationController

  def notice
  end
  # GET /book_posts
  # GET /book_posts.json
  def index
    @user = current_user

    if @user
      @book_posts = @user.book_posts
      @books = @user.books

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @book_posts }
      end
    else
      redirect_to log_in_path
    end
  end

  # GET /book_posts/1
  # GET /book_posts/1.json
  def show
    @user = current_user
    @book_post = BookPost.find(params[:id])
    @book = Book.find(@book_post.book_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book_post }
    end
  end

  # GET /book_posts/new
  # GET /book_posts/new.json
  def new
    @book = Book.new
    @book_post = @book.book_posts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book_post }
    end
  end

  # GET /book_posts/1/edit
  def edit
    @book_post = BookPost.find(params[:id])
    @book = Book.find(@book_post.book_id)
  end

  # POST /book_posts
  # POST /book_posts.json
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        @book_post = @book.book_posts.first
        format.html { redirect_to @book_post, notice: 'Book post was successfully created.' }
        format.json { render json: @book_post, status: :created, location: @book_post }
      else
        format.html { render action: "new" }
        format.json { render json: @book_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /book_posts/1
  # PUT /book_posts/1.json
  def update
    @book_post = BookPost.find(params[:id])

    respond_to do |format|
      if @book_post.update_attributes(params[:book_post])
        format.html { redirect_to @book_post, notice: 'Book post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_posts/1
  # DELETE /book_posts/1.json
  def destroy
    @book_post = BookPost.find(params[:id])
    @book_post.destroy

    respond_to do |format|
      format.html { redirect_to book_posts_url }
      format.json { head :no_content }
    end
  end
end