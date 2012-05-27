class NotificationsController < ApplicationController
  def index
    @notifications = User.find(params[:id]).notifications.order("created_at DESC")
  end
end
