# == Schema Information
# Schema version: 20100717055206
#
# Table name: use_cases
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  test_cases          :text
#  use_case_diagram_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  creator_id          :integer(4)
#  updater_id          :integer(4)
#

require 'use_case/acceptance_tests'

class UseCase < Base
  stampable
  validates_presence_of :name, :use_case_diagram
  belongs_to :use_case_diagram
  has_and_belongs_to_many :requirements
  belongs_to :created_by, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updater_id"

  validate :honors_grammar?, :unless => lambda {|u| u.test_cases.blank? }
  
  def ppee_test
    @ppee_test ||= PPEE::Test.new(PPEE::GrammarParser.new.parse_or_fail(test_cases).build) unless test_cases.blank?
  end
  
  private
  
  def honors_grammar?
    PPEE::GrammarParser.new.parse_or_fail(test_cases)
  rescue Exception => e
    errors.add(:test_cases, e.message)
  end
  
end
