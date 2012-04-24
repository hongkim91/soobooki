class BookPost < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  attr_accessible :book_id, :review, :user_id, :user
end
