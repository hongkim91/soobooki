class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation,\
                  :image, :remote_image_url, :info, :username

  validates :email, :presence => :true,
                    :uniqueness => :true,
                    :length => {:minimun => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :password, :length => {:minimun => 1, :maximum => 254}
  validates :username, :uniqueness => :true,
                       :length => {:minimun => 1, :maximum => 254},
                       :format => {:with => /^[a-z]+[a-z0-9\_\-]+$/i}

  has_many :book_posts, :dependent => :destroy
  has_many :books, :through => :book_posts

  mount_uploader :image, ProfilePicUploader

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_email_confirmation
    generate_token(:email_confirmation_token)
    save!
    UserMailer.email_confirmation(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
