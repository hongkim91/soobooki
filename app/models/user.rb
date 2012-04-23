class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation,\
                  :image, :remote_image_url, :info
  attr_accessor :password
  has_many :book_posts, :dependent => :destroy
  has_many :books, :through => :book_posts

  before_save :encrypt_password

  mount_uploader :image, ProfilePicUploader

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :image, :on => :update

  def self.authenticate(email,password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password,user.password_salt)
      user
    else
      nil
    end
  end
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
    end
  end
end
