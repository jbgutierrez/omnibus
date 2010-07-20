# == Schema Information
# Schema version: 20100717055206
#
# Table name: versions
#
#  id              :integer(4)      not null, primary key
#  project_id      :integer(4)      default(0), not null
#  name            :string(255)     default("")
#  description     :string(255)     default("")
#  effective_date  :date
#  created_on      :datetime
#  updated_on      :datetime
#  wiki_page_title :string(255)
#

class FixedVersion < Base
  establish_connection :redmine
  set_table_name :versions
  has_many :issues
end
