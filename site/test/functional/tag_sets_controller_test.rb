require 'test_helper'

class TagSetsControllerTest < ActionController::TestCase
  fixtures :tag_sets
  
  setup do
    @tag_set = tag_sets(:dave_rails_set)
    @update_tags = {
      hacker_id: 1,
      tags: "New, Tags"
    }
    @update_name = {
      hacker_id: 1,
      name: "New Name"
    }
  end

  test "authorized user should get index" do
    login_as(:dave)
    get :index
    assert_response :success
    assert_not_nil assigns(:tag_sets)
  end

  test "unauthorized user should not get index" do
    logout
    get :index
    assert_redirected_to login_url
  end
    
  test "authorized user should get new" do
    login_as(:dave)
    get :new
    assert_response :success
  end

  test "unauthorized user should not get new" do
    logout
    get :new
    assert_redirected_to login_url
  end
  
  test "authorized user should create tag_set" do
    login_as(:dave)
    assert_difference('TagSet.count') do
      post :create, tag_set: { hacker_id: @tag_set.hacker_id, name: @tag_set.name, tags: @tag_set.tags }
    end

    assert_redirected_to tag_set_path(assigns(:tag_set))
  end

  test "unauthorized user should not create tag_set" do
    logout
    post :create, tag_set: { hacker_id: @tag_set.hacker_id, name: @tag_set.name, tags: @tag_set.tags }
    assert_redirected_to login_url
  end
  
  test "authorized owner should show tag_set" do
    login_as(:dave)
    get :show, id: @tag_set
    assert_response :success
  end

  test "authorized non-owner should not show tag_set" do
    login_as(:mike)
    get :show, id: @tag_set
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not show tag_set" do
    logout
    get :show, id: @tag_set
    assert_redirected_to login_url
  end
  
  test "authorized owner should get edit" do
    login_as(:dave)
    get :edit, id: @tag_set
    assert_response :success
  end

  test "authorized non-owner should not get edit" do
    login_as(:mike)
    get :edit, id: @tag_set
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not get edit" do
    logout
    get :edit, id: @tag_set
    assert_redirected_to login_url
  end
  
  test "should update tag_set" do
    put :update, id: @tag_set, tag_set: { hacker_id: @tag_set.hacker_id, name: @tag_set.name, tags: @tag_set.tags }
    assert_redirected_to tag_set_path(assigns(:tag_set))
  end

  test "authorized owner should destroy tag_set" do
    login_as(:dave)
    assert_difference('TagSet.count', -1) do
      delete :destroy, id: @tag_set
    end

    assert_redirected_to tag_sets_path
  end
  
  test "authorized non-owner should not destroy tag_set" do
    login_as(:mike)
    assert_difference('TagSet.count', 0) do
      delete :destroy, id: @tag_set
    end
    
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not destroy tag_set" do
    logout
    assert_difference('TagSet.count', 0) do
      delete :destroy, id: @tag_set
    end
    
    assert_redirected_to login_url
  end
  
end
