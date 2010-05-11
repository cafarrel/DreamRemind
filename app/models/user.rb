# == Schema Information
# Schema version: 20100506071916
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  gender          :string(255)
#  birthday        :date
#  username        :string(255)
#  hashed_password :string(255)
#  email           :string(255)
#  salt            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :reminders
  has_many :categories
  
  validates_length_of :username, :within => 3..40
  
  validates_length_of :password, :within => 5..40, :on => :update, :if => :password_required?
  validates_confirmation_of :password, :on => :update, :if => :password_required?
  validates_presence_of :password, :password_confirmation, :on => :update, :if => :password_required?  
  validates_length_of :password, :within => 5..40, :on => :create
  validates_confirmation_of :password, :on => :create
  validates_presence_of :password, :password_confirmation, :on => :create
  
  validates_presence_of :username, :email, :salt
  
  validates_uniqueness_of :username, :email
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email address"
    
  attr_protected :id, :salt
  
  attr_accessor :password, :password_confirmation
  
  def to_param
    username
  end

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end
  
  def self.find_by_identifier(identifier)
    find(:first, :conditions => ["id = ? OR username = ?", identifier, identifier])
  end
  
  def self.authenticate(username, pass)
    u = find(:first, :conditions => ["username = ?", username])
    
    return nil if u.nil?  
    return u if User.encrypt(pass, u.salt) == u.hashed_password 
  end
  
  def send_new_password
    new_pass = User.random_string(10)
    
    self.password = self.password_confirmation = new_pass
    self.save
    
    Notifications.deliver_forgot_password(self.email, self.username, new_pass)
  end
  
  def send_registration_notification
    Notifications.deliver_registration_notification(self.email, self.username)
  end
  
  protected
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
  
  
  def self.random_string(len)
    # generates a random password consisting of strings and digits
      
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    
    return newpass  
  end
  
  def password_required?
    !password.blank?
  end
end
