# == Schema Information
# Schema version: 20100717055206
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(30)      default(""), not null
#  hashed_password   :string(40)      default(""), not null
#  firstname         :string(30)      default(""), not null
#  lastname          :string(30)      default(""), not null
#  mail              :string(60)      default(""), not null
#  mail_notification :boolean(1)      default(TRUE), not null
#  admin             :boolean(1)      not null
#  status            :integer(4)      default(1), not null
#  last_login_on     :datetime
#  language          :string(5)       default("")
#  auth_source_id    :integer(4)
#  created_on        :datetime
#  updated_on        :datetime
#  type              :string(255)
#

require "digest/sha1"
require "user/work_schedule"
class User < Base
  model_stamper
  establish_connection :redmine
  has_many :events
    
  def self.try_to_login(login, password)
    !password.blank? && first(:conditions => ["login=? and hashed_password=?", login, hash_password(password)])
  end
  
  def schedule
    @schedule ||= lambda{
      schedule = WorkSchedule.new("8:00 AM", "3:00 PM")
      schedule.set_holidays_on :sat, :sun
      schedule
    }.call;
  end

  private

  def self.hash_password(clear_password)
    Digest::SHA1.hexdigest(clear_password)
  end
end

class AnonymousUser < User
  
end
