class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation,\
                  :image, :remote_image_url, :info

  validates :email, :presence => :true,
                    :uniqueness => :true,
                    :length => {:minimun => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :password, :length => {:minimun => 1, :maximum => 254}
  validates_presence_of :image, :on => :update

  has_many :book_posts, :dependent => :destroy
  has_many :books, :through => :book_posts

  mount_uploader :image, ProfilePicUploader
end
