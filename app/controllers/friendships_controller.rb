class FriendshipsController < ApplicationController
  # GET /friendships
  # GET /friendships.json
  def index
    @users = User.where('email_confirmed = true AND email != \''+current_user.email+'\'')
    @direct_friendships = current_user.direct_friendships
    @inverse_friendships = current_user.inverse_friendships
    @friends = current_user.friends

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = current_user.direct_friendships.build(:friend_id => params[:friend_id])

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to friendships_path, notice: 'Added Friend.' }
        format.json { render json: @friendship, status: :created, location: @friendship }
      else
        format.html { redirect_to friendships_path, notice: 'Unable to add friend.'}
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to friendships_url, notice: 'Deleted Friend.'}
      format.json { head :no_content }
    end
  end
end
