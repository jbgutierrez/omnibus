# == Schema Information
# Schema version: 20100717055206
#
# Table name: enumerations
#
#  id         :integer(4)      not null, primary key
#  opt        :string(4)       default(""), not null
#  name       :string(30)      default(""), not null
#  position   :integer(4)      default(1)
#  is_default :boolean(1)      not null
#

class Activity < Base
  establish_connection :redmine  
  set_table_name :enumerations
  default_scope :conditions => { :opt => 'ACTI' }, :order => :position
  has_many :time_trackers
  def to_s
    name
  end
end
