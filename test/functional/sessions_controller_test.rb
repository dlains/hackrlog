require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    dave = hackers(:dave)
    post :create, :email => dave.email, :password => 'dave'
    assert_redirected_to entries_url
    assert_equal dave.id, session[:hacker_id]
  end
  
  test "should fail login" do
    dave = hackers(:dave)
    post :create, :email => dave.email, :password => 'wrong'
    assert_redirected_to login_url
  end
  
  test "should logout" do
    delete :destroy
    assert_redirected_to home_url
    assert_nil session[:hacker_id]
  end

end
