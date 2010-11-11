require 'digest'

class User < ActiveRecord::Base
has_many :microposts, :dependent => :destroy
has_many :relationships, :foreign_key => "follower_id",
                         :dependent => :destroy

has_many :following, :through => :relationships, :source => :followed

has_many :reverse_relationships, :foreign_key => "followed_id",
                                 :class_name => "Relationship",
                                 :dependent => :destroy
has_many :followers, :through => :reverse_relationships, :source => :follower



attr_accessor :password
attr_accessible :name, :email, :password, :password_confirmation
# Automatically create the virtual attribute 'password_confirmation'.
validates :password, :presence     => true,
                     :confirmation => true,
                     :length       => { :within => 6..40 }

validates :name, :presence => true,
                 :length   => { :maximum => 50 }

before_save :encrypt_password

def following?(followed)
  relationships.find_by_followed_id(followed)
end
def follow!(followed)
  relationships.create!(:followed_id => followed.id)
end

def unfollow!(followed)
  relationships.find_by_followed_id(followed).destroy
end



# Return true if the user's password matches the submitted password.
def has_password?(submitted_password)
  # Compare encrypted_password with the encrypted version of
  # submitted_password.
end

def self.authenticate(email, submitted_password)
  user = find_by_email(email)
  return nil if user.nil?
  return user if user.has_password?(submitted_password)
end

def self.authenticate_with_salt(id, cookie_salt)
  user = find_by_id(id)
  return nil if user.nil?
  return user if user.salt == cookie_salt
end

def feed
  Micropost.from_users_followed_by(self)
end



private
  def encrypt_password
    self.encrypted_password = encrypt(password)
  end
  def encrypt(string)
    string # Only a temporary implementation!
  end

def make_salt
  secure_hash("#{Time.now.utc}--#{password}")
end
def secure_hash(string)
  Digest::SHA2.hexdigest(string)
end


end
