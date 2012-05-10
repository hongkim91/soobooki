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
#    return render :text => "params #{params}"
    @book = Book.new(params[:book])

    unless @book.book_posts.empty?
      book_post = @book.book_posts.first
      book_post.user_id = current_user.id
      book_post.review = Sanitize.clean(book_post.review,Sanitize::Config::RELAXED)
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
        format.html { 
          if @book.book_posts.empty?
            render action: "new"
          else
            @book_post = @book.book_posts.first
            render 'book_posts/new'
          end
        }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = current_user.books.find(params[:id])
#    return render :text => "params #{params}"
    review = params[:book][:book_posts_attributes]["0"][:review]
    params[:book][:book_posts_attributes]["0"][:review] = Sanitize.clean(review,Sanitize::Config::RELAXED)

    respond_to do |format|
      if @book.update_attributes!(params[:book])
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

  def search
#    @books = Book.all
    url = URI::HTTPS.build(:host  => 'www.googleapis.com',
                           :path  => '/books/v1/volumes',
                           :query => 'q='+params[:query])
    @response = HTTParty.get(url.to_s)

    respond_to do |format|
      format.js
    end
  end
end
