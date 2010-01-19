require 'test_helper'

class CheckersControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Checker.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Checker.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_edit
    get :edit, :id => Checker.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Checker.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Checker.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Checker.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Checker.first
    assert_redirected_to root_url
  end
end
