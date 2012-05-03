class BookPostsController < ApplicationController

  # GET /book_posts
  # GET /book_posts.json
  def index
    if params.has_key?(:id)
      if params[:id] =~ /[0-9]+/
        @user = User.find(params[:id])
      else
        @user = User.find_by_username!(params[:id])
      end
    else
      @user = current_user
    end

    if @user
      @book_posts = @user.book_posts.order("year DESC","month DESC","day DESC")
#      return render :text => "bp: #{@book_posts.to_yaml}"
      @books = @user.books
#      @book_posts.each do |bp|
#        if bp.day
#          @book_posts_by_date[bp.year][bp.month][bp.day] = bp
#        elsif bp.month
#          @book_posts_by_date[bp.year][bp.month] = bp
#        else
#          @book_posts_by_date[bp.year]= bp
#        end
#      end

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
    @user = @book_post.user
    @book = Book.find(@book_post.book_id)
    
    raise AcessDenied unless @user.id == @book_post.user_id or 
      @book_post.user.friends.include?(@user)

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
    @book_post.year = Time.now.year
    @book_post.month = Time.now.month
    @book_post.day = Time.now.day

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book_post }
    end
  end

  # GET /book_posts/1/edit
  def edit
    @book_post = BookPost.find(params[:id])
    @book = Book.find(@book_post.book_id)
    raise AcessDenied unless current_user.id == @book_post.user_id
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
    raise AcessDenied unless current_user.id == @book_post.user_id

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
    raise AcessDenied unless current_user.id == @book_post.user_id

    @book_post.destroy

    respond_to do |format|
      format.html { redirect_to book_posts_url, notice: 'Book post was successfully deleted.'}
      format.json { head :no_content }
    end
  end
end
