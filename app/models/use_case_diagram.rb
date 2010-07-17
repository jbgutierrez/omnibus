# == Schema Information
# Schema version: 20100717055206
#
# Table name: use_case_diagrams
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  functional_area_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class UseCaseDiagram < ActiveRecord::Base
  belongs_to :functional_area
  has_many :use_cases
end
