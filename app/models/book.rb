class Book < ActiveRecord::Base
  attr_accessible :image, :title, :remote_image_url, :book_posts_attributes
  has_many :book_posts
  accepts_nested_attributes_for :book_posts

  before_destroy :ensure_not_referenced_by_any_line_item

  validates_presence_of :image

  mount_uploader :image, ImageUploader
end
