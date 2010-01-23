require 'test_helper'

class RequirementsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Requirement.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Requirement.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Requirement.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to requirement_url(assigns(:requirement))
  end
  
  def test_edit
    get :edit, :id => Requirement.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Requirement.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Requirement.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Requirement.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Requirement.first
    assert_redirected_to requirement_url(assigns(:requirement))
  end
  
  def test_destroy
    requirement = Requirement.first
    delete :destroy, :id => requirement
    assert_redirected_to requirements_url
    assert !Requirement.exists?(requirement.id)
  end
end
