class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to books_path
    else
      render "new"
    end
  end
  
  def create
    user = User.authenticate(params[:email],params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "User logged in"
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
