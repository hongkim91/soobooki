class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_email_confirmation
      redirect_to root_url, :notice => "A confirmation link was sent to your email. 
                          Please click the on the link to finish sign up!"
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    respond_to do |format|
      if @user.save
        format.html { redirect_to book_posts_path,
                      notice: 'user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def email_confirmation
    @user = User.find_by_email_confirmation_token(params[:id])
    if @user
      @user.email_confirmed = true
      @user.save!
      session[:user_id] = @user.id
      redirect_to book_posts_path, :alert => "Email has been confirmed. Sign up complete!"
    else
      redirect_to root_url, :alert => "Email confirmation token was incorrect.
                                       Please try again."
    end
  end

  def need_confirmation
  end
  
  def send_confirmation
    if session[:user_email]
      user = User.find_by_email(session[:user_email])
      user.send_email_confirmation
      redirect_to root_url, :notice => "Confirmation email has been sent!"
    else
      redirect_to root_url, :notice => "Email information not found.
                      Try logging in or signing up."
    end
  end
end
