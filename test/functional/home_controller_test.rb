require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_select 'ul.nav', 1
    assert_select '.container .hero-unit', 1
    assert_select 'footer', 1
  end

end
