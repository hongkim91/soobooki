class CommentObserver < ActiveRecord::Observer
  def after_create(model)
    sender = model.user
    book_post_owner = model.book_post.user
    unless sender == book_post_owner
      book_post_owner.notifications.create(sender_id: sender.id, comment_id: model.id,
                                    notification_type: "new comment on my book_post")
    end
    commenters = []
    model.book_post.comments do |comment|
      unless commenters.include?(comment.user)
        commenters << comment.user
      end
    end
    commenters.each do |commenter|
      unless commenter == book_post_owner
        commenter.notifications.create(sender_id: sender.id, comment_id: model.id,
                                notification_type: "potential comment reply")
      end
    end
  end
end

