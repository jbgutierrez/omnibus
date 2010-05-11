require 'acceptance_tests'

class UseCase < ActiveRecord::Base
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
