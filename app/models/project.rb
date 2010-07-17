# == Schema Information
# Schema version: 20100717055206
#
# Table name: projects
#
#  id             :integer(4)      not null, primary key
#  name           :string(30)      default(""), not null
#  description    :text
#  homepage       :string(255)     default("")
#  is_public      :boolean(1)      default(TRUE), not null
#  parent_id      :integer(4)
#  projects_count :integer(4)      default(0)
#  created_on     :datetime
#  updated_on     :datetime
#  identifier     :string(20)
#  status         :integer(4)      default(1), not null
#

class Project < ActiveRecord::Base
  establish_connection :redmine  
  has_many :versions
  has_many :issues
  
  COLORS = ["#CD5C5C", "#F08080", "#FA8072", "#E9967A", "#FFA07A", "#DC143C", "#FF0000", "#FFC0CB", "#FFA500", "#FFD700", "#EE82EE", "#008000", "#00FFFF", "#D2691E", "#C0C0C0"]
  def color
    COLORS[id]
  end
  
end
