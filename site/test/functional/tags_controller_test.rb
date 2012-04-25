require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:dave_mysql)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag" do
    assert_difference('Tag.count') do
      post :create, tag: { hacker_id: @tag.hacker_id, name: @tag.name }
    end

    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should show tag" do
    login_as(:dave)
    get :show, id: @tag
    assert_response :success
  end

  test "should get edit" do
    login_as(:dave)
    get :edit, id: @tag
    assert_response :success
  end

  test "should update tag" do
    login_as(:dave)
    put :update, id: @tag, tag: { hacker_id: @tag.hacker_id, name: @tag.name }
    assert_redirected_to tag_path(assigns(:tag))
  end

  test "should destroy tag" do
    login_as(:dave)
    assert_difference('Tag.count', -1) do
      delete :destroy, id: @tag
    end

    assert_redirected_to tags_path
  end
end