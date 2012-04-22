class BookPostsController < ApplicationController
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
    @book_post = BookPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book_post }
    end
  end

  # GET /book_posts/1/edit
  def edit
    @book_post = BookPost.find(params[:id])
  end

  # POST /book_posts
  # POST /book_posts.json
  def create
    user = current_user
    book = Book.new({title: params[:title],image: params[:image],
                      remote_image_url: params[:remote_image_url]})
    if book.save
      @book_post = BookPost.new({user_id: user.id, book_id: book.id, review: params[:review]})

      respond_to do |format|
        if @book_post.save
          format.html { redirect_to @book_post, notice: 'Book post was successfully created.' }
          format.json { render json: @book_post, status: :created, location: @book_post }
        else
          format.html { render action: "new" }
          format.json { render json: @book_post.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "book creation failed"
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
