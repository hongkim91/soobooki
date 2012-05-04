class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to bookshelf(current_user)
    else
      render "new"
    end
  end
  
  def create
    user = User.find_by_email(params[:email])
    begin
      if user && user.authenticate(params[:password])
        if user.email_confirmed
          session[:user_id] = user.id
          redirect_to bookshelf(current_user), :notice => "User logged in"
        else
          session[:user_email] = user.email
          redirect_to need_confirmation_path
        end
      else
        flash.now.alert = "Invalid email or password"
        render "new"
      end
    rescue BCrypt::Errors::InvalidHash
      flash.now.alert = "You have not signed up with a password, but rather through 
                          #{user.authentications.first.provider}."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to log_in_path, :notice => "User logged out!"
  end
end
