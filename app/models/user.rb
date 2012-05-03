class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation,\
                  :image, :remote_image_url, :info, :username

  validates :email, :presence => :true,
                    :uniqueness => {:case_sensitive => false},
                    :length => {:minimun => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :password, :length => {:minimun => 1, :maximum => 254}
  validates :username, :uniqueness => {:case_sensitive => false},
                       :length => {:minimun => 1, :maximum => 254},
                       :format => {:with => /^[a-z]+[a-z0-9\_\-]+$/i},
                       :allow_blank => true

  has_many :book_posts, :dependent => :destroy
  has_many :books, :through => :book_posts

  has_many :direct_friendships, :class_name => "Friendship", :dependent => :destroy,
           :conditions => "approved = true"
  has_many :direct_friends, :through => :direct_friendships, :source => :friend
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id",
           :conditions => "approved = true"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :pending_friendships, :class_name => "Friendship",
           :conditions => "approved = false"
  has_many :pending_friends, :through => :pending_friendships, :source => :friend
  has_many :requested_friendships, :class_name => "Friendship",
           :conditions => "approved = false", :foreign_key => "friend_id"
  has_many :requested_friends, :through => :requested_friendships, :source => :user
  mount_uploader :image, ProfilePicUploader

  def friends
    direct_friends | inverse_friends
  end

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
