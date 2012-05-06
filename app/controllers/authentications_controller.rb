class AuthenticationsController < ApplicationController
  def index
    if current_user
      @user = current_user
      redirect_to user_path(current_user)
    else
      redirect_to log_in_path
    end
  end

  def create
    auth_hash = request.env['omniauth.auth']
    provider = auth_hash['provider'].titleize
    auth = Authentication.
      find_by_provider_and_uid(provider,auth_hash['uid'])
    if current_user
      if auth
        user = User.find_by_email(auth_hash["info"]["email"])
        if user && user.only_omniauth?
          user.destroy
        end
        flash[:notice] = "Previous signup through this Facebook account was deleted. New authentication successfully added!"
      else
        flash[:notice] = "Authentication added! You can now log in using #{provider}!"
      end
      current_user.authentications.create(:provider => provider,:uid => auth_hash['uid'])
      redirect_to user_path(current_user)
    else
      if auth
        session[:user_id] = auth.user_id
        redirect_to bookshelf(current_user), 
                    :notice => "Successfully logged in through #{provider}!"
      else
        user = User.find_by_email(auth_hash["info"]["email"])
        if user
          flash[:notice] = "Authentication added! You can now log in using #{provider}!"
        else
          user = User.new(:email => auth_hash["info"]["email"])
          flash[:notice] = "Successfully signed up through #{provider}!"
        end
        user.email_confirmed = true
        user.authentications.build(:provider => provider,
                                   :uid => auth_hash["uid"])
        user.save!(:validate => false)
        session[:user_id] = user.id
        redirect_to user_path(current_user)
      end
    end
  end

  def destroy
    auth = current_user.authentications.find(params[:id])
    unless current_user.only_omniauth?
      auth.destroy
      redirect_to user_path(current_user), 
      :notice => "Successfully deleted authentication from #{auth.provider}."
    else
      redirect_to user_path(current_user), 
      :notice => "Couldn't delete authentication from #{auth.provider} because it is your only authentication method."
    end
  end

  def failure
    flash[:error] = 'There was an error at the remote authentication service. You have not been signed in.'
    redirect_to root_url
  end
end
