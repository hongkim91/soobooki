class AuthenticationsController < ApplicationController
  def index
    if current_user
      @authentications = current_user.authentications
    else
      redirect_to log_in_path
    end
  end

  def create
    auth_hash = request.env['omniauth.auth']
    if current_user
      current_user.authentications.
        find_or_create_by_provider_and_uid(auth_hash['provider'],auth_hash['uid'])
      redirect_to authentications_path, 
                  :notice => "You can now log in using #{auth_hash['provider']}!"
    else
      auth = Authentication.
        find_by_provider_and_uid(auth_hash['provider'],auth_hash['uid'])
      if auth
        session[:user_id] = auth.user_id
        redirect_to authentications_path, 
                    :notice => "Successfully logged in through #{auth_hash['provider']}!"
      else
        user = User.new(:email => auth_hash["info"]["email"])
        user.email_confirmed = true
        user.authentications.build(:provider => auth_hash["provider"],
                                   :uid => auth_hash["uid"])
        user.save!(:validate => false)
        session[:user_id] = user.id
        redirect_to authentications_path,
                    :notice => "Successfully signed up through #{auth_hash['provider']}!"
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  end
end
