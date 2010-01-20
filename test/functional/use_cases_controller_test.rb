require 'test_helper'

class UseCasesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_edit
    get :edit, :id => UseCase.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    UseCase.any_instance.stubs(:valid?).returns(false)
    put :update, :id => UseCase.first
    assert_template 'edit'
  end
  
  def test_update_valid
    UseCase.any_instance.stubs(:valid?).returns(true)
    put :update, :id => UseCase.first
    assert_redirected_to use_cases_url
  end
end
