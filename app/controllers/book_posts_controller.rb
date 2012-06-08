class BookPostsController < ApplicationController
  # GET /book_posts
  # GET /book_posts.json
  def index
    if params.has_key?(:id)
      if params[:id] =~ /[0-9]+/
        @user = User.find(params[:id])
      else
        @user = User.find_by_bookshelf_name!(params[:id])
      end
    else
      if current_user.present?
        @user = current_user
      else
        redirect_to log_in_path, notice: "Plase log in first." and return
      end
    end
    unless @user.bookshelf_privacy == "Everyone"
      unless current_user.present?
        redirect_to log_in_path,
        notice: "You must first log in to view #{user_name(@user)}'s bookshelf." and return
      end
    end
    if @user.bookshelf_privacy == "Only Me"
      unless current_user == @user
        redirect_to bookshelf(current_user),
        notice: "#{user_name(@user)}'s bookshelf is private." and return
      end
    elsif @user.bookshelf_privacy == "Friends"
      unless current_user == @user or @user.friends.include?(current_user)
        redirect_to friendships_path,
        notice: "#{user_name(@user)}'s bookshelf is only open to friends."+
          " Send a friend request!" and return
      end
    end
    if @user
      increment_size = 10
      previous_book_post = nil
      if params[:next_index]
        book_posts = @user.book_posts.order("year DESC","month DESC","day DESC","created_at DESC")
                         .limit(increment_size).offset(params[:next_index])
        @next_index = increment_size + params[:next_index].to_i
        previous_book_post = @user.book_posts.order("year DESC","month DESC","day DESC","created_at DESC")
                         .limit(1).offset(params[:next_index].to_i-1).first
      else
        book_posts = @user.book_posts.order("year DESC","month DESC","day DESC","created_at DESC").limit(increment_size)
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

    if @book_post.privacy == "Only Me"
      unless current_user == @user
        redirect_to bookshelf(@user),
        notice: "#{user_name(@user)}'s book review on #{@book_post.book.title} is private." and return
      end
    elsif @book_post.privacy == "Friends"
      unless current_user == @user or @user.friends.include?(current_user)
        redirect_to bookshelf(@user),
        notice: "#{user_name(@user)}'s book review on"+
          " '#{@book_post.book.title}' is only open to friends. Send a friend request!" and return
      end
    elsif @book_post.privacy == "Users"
      unless current_user.present?
        redirect_to bookshelf(@user),
        notice: "You must first log in to view #{user_name(@user)}'s"+
          " book review on #{@book_post.book.title}." and return
      end
    end

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

  def create
    #TODO: improve so that image links can be blank <- add default image
    #TODO: check if the book already exists.
    if params[:api] == "google"
      url = URI::HTTPS.build(:host  => 'www.googleapis.com',
                       :path  => '/books/v1/volumes/'+params[:google_book_id])
      response = HTTParty.get(url.to_s)
      book = response['volumeInfo']
      title = params[:title]
      image_url = nil
      if book['imageLinks']
        if book['imageLinks']['small']
          image_url = book['imageLinks']['small']
        elsif book['imageLinks']['thumbnail']
          image_url = book['imageLinks']['thumbnail']
        end
      end
      isbn = "todo"
      isbn13 = "todo"
    elsif params[:api] == "daum"
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

  def edit_privacy
    @book_post = BookPost.find(params[:id])
    @book_post.privacy = params[:privacy]
    respond_to do |format|
      if @book_post.save
        format.js
      end
    end
  end
end


