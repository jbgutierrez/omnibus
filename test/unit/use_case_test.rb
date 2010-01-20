require 'test_helper'

class UseCaseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert UseCase.new.valid?
  end
end
