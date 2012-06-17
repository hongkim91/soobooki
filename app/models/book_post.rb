class BookPost < ActiveRecord::Base
  attr_accessible :book_id, :review, :user_id, :user, :year,:month,:day,
                  :title, :image, :remote_image_url

  belongs_to :book
  belongs_to :user

  has_many :comments, order: 'created_at', dependent: :destroy
  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  def title
    if super.present?
      return super
    else
      return book.title unless book.nil?
    end
  end

  def image_url(*args)
    if super.present?
      return super
    else
      return book.image_url(*args) unless book.nil?
    end
  end
end
