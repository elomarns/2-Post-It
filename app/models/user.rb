require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :tasks

  validates_presence_of :login, :message => "No login, no sign up!"
  validates_uniqueness_of :login, :case_sensitive => false,
    :message => "Bad news, someone's using this login."

  attr_accessible :login, :password, :password_confirmation
  
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?

    user = find_by_login(login)

    user && user.authenticated?(password) ? user : nil
  end
end