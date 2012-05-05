require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_select '#nav a', :minimum => 3
    assert_select '#content #description', 1
    assert_select '#page_footer', 1
  end

end
