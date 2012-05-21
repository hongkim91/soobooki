class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :book_post
  attr_accessible :body, :commenter

  validates_length_of :body, :minimun => 1, :maximum => 1024
end
