class UseCaseDiagram < ActiveRecord::Base
  belongs_to :functional_area
  has_many :use_cases
end
