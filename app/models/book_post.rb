class BookPost < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  has_many :comments, order: 'created_at'
  has_many :notifications, dependent: :destroy

  attr_accessible :book_id, :review, :user_id, :user, :year,:month,:day
end
