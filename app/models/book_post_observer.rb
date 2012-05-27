class BookPostObserver < ActiveRecord::Observer
  def after_create(model)
    friends = model.user.friends
    friends.each do |friend|
      friend.notifications.create(sender_id: model.user.id, book_post_id: model.id,
                          notification_type: "friend's new book_post")
    end
  end
end
