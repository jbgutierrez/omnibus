require 'acceptance_tests'

class UseCase < ActiveRecord::Base
  belongs_to :use_case_diagram
  has_and_belongs_to_many :requirements

  validates_presence_of :name
  validate :honors_grammar?, :unless => lambda {|u| u.test_cases.blank? }
  
  def ppee_test
    @ppee_test ||= PPEE::Test.new(PPEE::GrammarParser.new.parse_or_fail(test_cases).build) unless test_cases.blank?
  end
  
  private
  
  def honors_grammar?
    PPEE::GrammarParser.new.parse_or_fail(test_cases)
  rescue Exception => e
    errors.add_to_base(e.message)
  end
  
end
