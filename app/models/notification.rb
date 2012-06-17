class Notification < ActiveRecord::Base
  attr_accessible :receiver_id, :sender_id, :book_post_id, :comment_id, :type,
                  :notification_type

  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :book_post
  belongs_to :movie_post
  belongs_to :comment
end
