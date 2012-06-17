class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation, :image, :remote_image_url,\
                  :info, :soobooki_id, :first_name, :last_name, :crop_x, :crop_y, :crop_w, :crop_h

  validates :email, :presence => :true,
                    :uniqueness => {:case_sensitive => false},
                    :length => {:minimun => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates_length_of :password, :minimun => 1, :maximum => 254
  validates :soobooki_id, :uniqueness => {:case_sensitive => false},
                       :length => {:minimun => 1, :maximum => 254},
                       :format => {:with => /^[a-z]+[a-z0-9\_\-]+$/i},
                       :allow_blank => true

  before_validation :no_password_omniauth

  has_many :authentications, :dependent => :destroy

  has_many :book_posts, :dependent => :destroy
  has_many :books, :through => :book_posts

  has_many :movie_posts, :dependent => :destroy
  has_many :movies, :through => :movie_posts

  has_many :comments, :dependent => :destroy

  has_many :notifications, :foreign_key => "receiver_id", :dependent => :destroy
  has_many :inverse_notifications, :class_name => "Notification",:foreign_key => "sender_id",
           :dependent => :destroy

  has_many :direct_friendships, :class_name => "Friendship", :dependent => :destroy,
           :conditions => "approved = true"
  has_many :direct_friends, :through => :direct_friendships, :source => :friend
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id",
           :dependent => :destroy, :conditions => "approved = true"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :pending_friendships, :class_name => "Friendship",
           :conditions => "approved = false"
  has_many :pending_friends, :through => :pending_friendships, :source => :friend
  has_many :requested_friendships, :class_name => "Friendship",
           :conditions => "approved = false", :foreign_key => "friend_id"
  has_many :requested_friends, :through => :requested_friendships, :source => :user

  mount_uploader :image, ProfilePicUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_image

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

  #the following two methods are a dirty hack to bypass the validate_presense_of :password
  #validtaion automatically genearated by "has_secure_password"
  def no_password_omniauth
    self.password_digest = 0 unless password_required
  end

  def password_required
    (authentications.empty? || !password_digest.blank?)
  end

  def only_omniauth?
    authentications.size == 1 and
      (password_digest.blank? or password_digest == 0)
  end

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  def get_fb_profile_pictures
    fb_auth = self.authentications.find_by_provider('Facebook')
    profile_pictures = []
    if fb_auth.present?
      url = URI::HTTPS.build(:host  => 'graph.facebook.com',
                       :path  => '/'+fb_auth.uid,
                       :query => 'access_token='+fb_auth.access_token+'&fields=albums')
      response = HTTParty.get(url.to_s)
      response['albums']['data'].each do |album|
        if album['name'] == "Profile Pictures"
          url = URI::HTTPS.build(:host  => 'graph.facebook.com',
                           :path  => '/'+album['id']+'/photos',
                           :query => 'access_token='+fb_auth.access_token)
          response = HTTParty.get(url.to_s)
          response['data'].each do |picture|
            profile_pictures << {thumbnail: picture['picture'], large: picture['source']}
          end
          return profile_pictures
        end
      end
    end
  end
end
