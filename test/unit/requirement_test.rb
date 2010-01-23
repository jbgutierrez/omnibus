require 'test_helper'

class RequirementTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Requirement.new.valid?
  end
end
