# == Schema Information
# Schema version: 20100717055206
#
# Table name: versioned_requirements
#
#  id              :integer(4)      not null, primary key
#  code            :string(255)
#  name            :string(255)
#  status          :string(255)
#  release_version :string(255)
#  date            :date
#  description     :text
#  requirement_id  :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  creator_id      :integer(4)
#  updater_id      :integer(4)
#

class VersionedRequirement < ActiveRecord::Base
end
