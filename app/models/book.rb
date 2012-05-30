class Book < ActiveRecord::Base
  attr_accessible :title, :image, :remote_image_url, :authors, :translators, :publisher,
                  :pub_date, :api_id, :isbn, :isbn13, :category, :book_posts_attributes
  has_many :book_posts
  accepts_nested_attributes_for :book_posts

#  validates_presence_of :image
  mount_uploader :image, ImageUploader
end
