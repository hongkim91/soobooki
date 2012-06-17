class CommentObserver < ActiveRecord::Observer
  def after_create(model)
    sender = model.user
    if model.book_post.present?
      post = model.book_post
    else
      post = model.movie_post
    end
    unless sender == post.user
      post.user.notifications.create(sender_id: sender.id, comment_id: model.id,
                                    notification_type: "new comment on my post")
    end
    commenters = []
    post.comments.each do |comment|
      unless commenters.include?(comment.user)
        commenters << comment.user
      end
    end
    commenters.each do |commenter|
      unless (commenter == post.user or commenter == model.user)
        commenter.notifications.create(sender_id: sender.id, comment_id: model.id,
                                notification_type: "potential comment reply")
      end
    end
  end
end
