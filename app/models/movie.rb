class Movie < ActiveRecord::Base
  attr_accessible :actors, :api_id, :director, :release_date, :title,
                  :image, :remote_image_url, :subtitle, :actor, :rating, :year

  has_many :movie_posts

  mount_uploader :image, ImageUploader
end
