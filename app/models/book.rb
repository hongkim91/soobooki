class Book < ActiveRecord::Base
  attr_accessible :image, :title, :remote_image_url
  has_many :book_posts
  
  before_destroy :ensure_not_referenced_by_any_line_item
  
  validates_presence_of :image, :on => :update

  mount_uploader :image, ImageUploader
end
