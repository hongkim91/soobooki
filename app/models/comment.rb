class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :book_post
  attr_accessible :body, :commenter
end
