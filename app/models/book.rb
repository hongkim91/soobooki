class Book < ActiveRecord::Base
  attr_accessible :image, :review, :title, :remote_image_url
  mount_uploader :image, ImageUploader
end
