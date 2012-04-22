class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation,\
                  :profile_pic, :remote_profile_pic_url
  attr_accessor :password
  has_many :book_posts, :dependent => :destroy
  has_many :books, :through => :book_posts

  before_save :encrypt_password

  mount_uploader :profile_pic, ProfilePicUploader

  validates_confirmation_of :password
  validates_presence_of :password
  validates_presence_of :email
  validates_uniqueness_of :email

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
