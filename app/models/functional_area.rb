# == Schema Information
# Schema version: 20100717055206
#
# Table name: functional_areas
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FunctionalArea < ActiveRecord::Base
  has_many :use_case_diagrams
end
