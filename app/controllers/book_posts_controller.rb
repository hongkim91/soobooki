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
    raise AcessDenied unless current_user == @user or @user.friends.include?(current_user)
    if @user
      increment_size = 10
      previous_book_post = nil
      if params[:next_index]
        book_posts = @user.book_posts.order("year DESC","month DESC","day DESC")
                         .limit(increment_size).offset(params[:next_index])
        @next_index = increment_size + params[:next_index].to_i
        previous_book_post = @user.book_posts.order("year DESC","month DESC","day DESC")
                         .limit(1).offset(params[:next_index].to_i-1).first
      else
        book_posts = @user.book_posts.order("year DESC","month DESC","day DESC").limit(increment_size)
        @next_index = increment_size
      end
      @book_posts_size = @user.book_posts.size

      @book_posts_by_year_and_month = {}
      book_posts.each do |book_post|
        if !@book_posts_by_year_and_month.include?(book_post.year)
          @book_posts_by_year_and_month[book_post.year] = {book_post.month => [book_post]}
        elsif !@book_posts_by_year_and_month[book_post.year].include?(book_post.month)
          @book_posts_by_year_and_month[book_post.year][book_post.month] = [book_post]
        else
          @book_posts_by_year_and_month[book_post.year][book_post.month] << book_post
        end
      end

      unless @book_posts_by_year_and_month.empty?
        max_year = @book_posts_by_year_and_month.keys().max
        max_month = @book_posts_by_year_and_month[max_year].keys().max

        if previous_book_post && (previous_book_post.year == max_year) &&
            (previous_book_post.month == max_month)
          @last_month_book_posts = @book_posts_by_year_and_month[max_year].delete(max_month)
          if @book_posts_by_year_and_month[max_year].empty?
            @book_posts_by_year_and_month.delete(max_year)
          end
        end
      end

      respond_to do |format|
        format.html # index.html.erb
        format.js
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

    raise AcessDenied unless current_user.id == @book_post.user_id or
      @book_post.user.friends.include?(current_user)

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
    @book_post = current_user.book_posts.find(params[:id])
    @book = Book.find(@book_post.book_id)
  end

  # POST /book_posts
  # POST /book_posts.json
  def create
    url = URI::HTTPS.build(:host  => 'www.googleapis.com',
                           :path  => '/books/v1/volumes/'+params[:google_book_id])
    response = HTTParty.get(url.to_s)
    book_info = response['volumeInfo']
#    return render text: "#{book_info['imageLinks']['small'].inspect}"
    #TODO: improve so that image links can be blank <- add default image
    #TODO: check if the book already exists.
    image_url = nil
    if book_info['imageLinks']
      if book_info['imageLinks']['small']
        image_url = book_info['imageLinks']['small']
      elsif book_info['imageLinks']['thumbnail']
        image_url = book_info['imageLinks']['thumbnail']
      end
    end
#    return render text: "image_url: #{image_url}"

    @book = Book.new(title: book_info['title'], remote_image_url: image_url)
    @book.book_posts.build(user_id: current_user.id, year: Time.now.year, month: Time.now.month,
                     day: Time.now.day)
    @google_book_id = params[:google_book_id]
    respond_to do |format|
      if @book.save!
        format.html { redirect_to @book_post, notice: 'Book post was successfully created.' }
        format.js
        format.json { render json: @book_post, status: :created, location: @book_post }
      else
        format.html { render action: "new" }
        format.js {alert("book add failed")}
        format.json { render json: @book_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /book_posts/1
  # PUT /book_posts/1.json
  def update
    @book_post = current_user.book_posts.find(params[:id])

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
    @book_post = current_user.book_posts.find(params[:id])
    @book_post.destroy

    respond_to do |format|
      format.html { redirect_to book_posts_url, notice: 'Book post was successfully deleted.'}
      format.json { head :no_content }
    end
  end

  def mercury_update
    book_post = current_user.book_posts.find(params[:id])
    book_post.review = Sanitize.clean(params[:content][:book_post_review][:value],Sanitize::Config::RELAXED)
    book_post.save!
    render text: ""
  end
end


