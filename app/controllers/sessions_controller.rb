class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to book_posts_path
    else
      render "new"
    end
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to book_posts_path, :notice => "User logged in"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to log_in_path, :notice => "User logged out!"
  end
end
