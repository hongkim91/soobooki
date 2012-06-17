class MoviePostObserver < ActiveRecord::Observer
  def after_create(model)
    friends = model.user.friends
    friends.each do |friend|
      friend.notifications.create(sender_id: model.user.id, movie_post_id: model.id,
                           notification_type: "friend's new post")
    end
  end

  def before_update(model)
    previous_privacy = MoviePost.find(model.id).privacy
    if previous_privacy == "Only Me"
      self.after_create(model)
    end
  end

  def after_update(model)
    if model.privacy == "Only Me"
      model.notifications.each do |notification|
        notification.destroy
      end
    end
  end
end
