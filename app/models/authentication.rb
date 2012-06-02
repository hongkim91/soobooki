class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :access_token
end
