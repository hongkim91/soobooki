class NotificationsController < ApplicationController
  before_filter :logged_in?

  def index
    @notifications = User.find(params[:id]).notifications.order("created_at DESC")
  end
end
