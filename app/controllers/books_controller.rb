class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    if current_user
      @books = Book.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @books }
      end
    else
      redirect_to log_in_path
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new
    @book.book_posts.build
    @book.book_posts.first.date_read = Time.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    raise AccessDenied
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])

    unless @book.book_posts.empty?
      book_post = @book.book_posts.first
      book_post.user_id = current_user.id
    end

    respond_to do |format|
      if @book.save
        format.html {
          if @book.book_posts.empty?
            redirect_to @book, notice: 'Book was successfully created.'
          else
            redirect_to book_post, notice: 'Book post was successfully added.'
          end
        }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])
#    return render :text => "params #{params}"
    raise AccessDenied unless current_user.id == @book.book_posts.first.user_id

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book.book_posts.first, notice: 'Book post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    raise AccessDenied unless current_user.admin?
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
end
