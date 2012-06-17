class MoviePost < ActiveRecord::Base
  attr_accessible :day, :month, :movie_id, :review, :title, :user_id, :year,
                  :image, :remote_image_url

  belongs_to :movie
  belongs_to :user

  has_many :comments, order: 'created_at', dependent: :destroy
  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  def title
    if super.present?
      return super
    else
      return movie.title unless movie.nil?
    end
  end

  def image_url(*args)
    if super.present?
      return super
    else
      return movie.image_url(*args) unless movie.nil?
    end
  end
end
