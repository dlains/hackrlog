require 'test_helper'

class HackersControllerTest < ActionController::TestCase
  setup do
    @input_attributes = {
      :email => "someone@somewhere.com",
      :name => "Someone",
      :password => "private",
      :password_confirmation => "private"
    }
    
    @update_attributes = {
      :email => "someone@somewhere.com",
      :name => "Someone",
      :password => "newhotness",
      :password_confirmation => "newhotness"
    }

    @hacker = hackers(:dave)
  end

  test "unauthenticated user should not get index" do
    logout
    get :index
    assert_redirected_to login_url
  end
  
  test "authenticated hacker should not get index" do
    login_as(:dave)
    get :index
    assert_redirected_to entries_url
  end
  
  test "everyone should get new" do
    logout
    get :new
    assert_response :success
    login_as(:dave)
    get :new
    assert_response :success
  end

  test "should create hacker" do
    assert_difference('Hacker.count') do
      post :create, :hacker => @input_attributes
    end

    assert_redirected_to entries_path
  end

  test "unauthenticated user should not show hacker" do
    logout
    get :show, :id => @hacker.to_param
    assert_redirected_to login_url
  end
  
  test "authenticated hacker should not show hacker" do
    login_as(:dave)
    get :show, :id => hackers(:dave).id
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not get edit" do
    logout
    get :edit, :id => @hacker.to_param
    assert_redirected_to login_url
  end
  
  test "authorized hacker should get edit" do
    login_as(:dave)
    get :edit, :id => hackers(:dave).id
    assert_response :success
  end

  test "hacker should not edit a different hacker" do
    login_as(:dave)
    get :edit, :id => hackers(:mike).id
    assert_redirected_to entries_path
    assert_equal('You do not have access to that information.', flash[:notice])
  end
  
  test "unauthorized user should not update hacker" do
    logout
    put :update, :id => @hacker.to_param, :hacker => @update_attributes
    assert_redirected_to login_url
  end
  
  test "hacker should not update a different hacker" do
    login_as(:dave)
    put :update, :id => hackers(:joe).id, :hacker => @update_attributes
    assert_redirected_to entries_path
    assert_equal('You do not have access to that information.', flash[:notice])
  end
  
  test "unauthorized user should not destroy hacker" do
    logout
    delete :destroy, :id => @hacker.to_param
    assert_redirected_to login_url
  end
  
  test "hacker can not destroy hacker" do
    login_as(:dave)
    delete :destroy, :id => @hacker.to_param
    assert_redirected_to entries_path
  end
end
