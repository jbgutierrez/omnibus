require 'acceptance_tests'

class UseCase < ActiveRecord::Base
  has_and_belongs_to_many :requirements
  belongs_to :use_case_diagram
  validates_presence_of :test_cases, :name
  
  validate :honors_grammar?
  
  def ppee_test
    @ppee_test ||= PPEE::Test.new(PPEE::GrammarParser.new.parse_or_fail(test_cases).build)
  rescue
    nil
  end
  
  private
  
  def honors_grammar?
    PPEE::GrammarParser.new.parse_or_fail(test_cases)
  rescue Exception => e
    errors.add_to_base(e.message)
  end
  
end
