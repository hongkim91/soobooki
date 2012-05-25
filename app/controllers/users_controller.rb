class UsersController < ApplicationController
  def index
    if current_user
      raise AcessDenied unless current_user.admin?
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      redirect_to log_in_path
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_email_confirmation
      redirect_to root_url, :notice => "A confirmation link was sent to your email. 
                          Please click on the link to finish sign up!"
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
    raise AccessDenied unless current_user.id == @user.id
  end

  def update
#    return render text: "#{params}"
    @user = User.find(params[:id])
    raise AccessDenied unless current_user.id == @user.id

    @user.attributes = params[:user]
    respond_to do |format|
      if @user.save
        format.html {
          if params[:user][:image].present? or params[:user][:remote_image_url].present?
#            return render text: "#{params}"
           redirect_to user_image_crop_path(@user)
          else
            redirect_to bookshelf(current_user),
            notice: 'User was successfully updated.'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def crop_image
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    raise AccessDenied unless current_user.id == @user.id || current_user.admin?
    @user.destroy

    respond_to do |format|
      format.html { 
        unless current_user.admin?
          session[:user_id] = nil
          redirect_to root_url, :notice => "User account deleted." 
        else
          redirect_to users_path, :notice => "User account deleted."
        end
      }
      format.json { head :no_content }
    end
  end

  def email_confirmation
    @user = User.find_by_email_confirmation_token(params[:id])
    if @user
      @user.email_confirmed = true
      @user.save!
      session[:user_id] = @user.id
      redirect_to bookshelf(current_user), :alert => "Email has been confirmed. Sign up complete!"
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
