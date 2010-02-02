require "digest/sha1"
class User < ActiveRecord::Base
  establish_connection :redmine
  
  def self.try_to_login(login, password)
    !password.blank? && first(:conditions => ["login=? and hashed_password=?", login, hash_password(password)])
  end

  private

  def self.hash_password(clear_password)
    Digest::SHA1.hexdigest(clear_password)
  end
  
end