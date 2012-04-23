require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  fixtures :hackers
  setup do
    @entry = entries(:dave_first_entry)
    @update = {
      :hacker_id => 1,
      :content => 'A note contains information for later use.'
    }
    @update_with_tags = {
      :hacker_id => 1,
      :content => 'This content has been updated.'
    }
  end

  test "should get index" do
    login_as(:dave)
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entry" do
    assert_difference('Entry.count') do
      post :create, :entry => @update
    end

    assert_redirected_to entries_url
  end

  test "should create entry with tags" do
    assert_difference('Entry.count') do
      post :create, {:tags => "Ruby", :entry => @update_with_tags}
    end
    
    assert_redirected_to entries_url
  end
  
  test "should show entry" do
    get :show, :id => @entry.to_param
    assert_response :success
  end

  # Log in as dave and try to see admin's entries.
  test "should not show entry" do
    login_as :dave
    get :show, :id => entries(:mike_markdown_table).id
    assert_redirected_to entries_url
  end

  test "should get edit" do
    get :edit, :id => @entry.to_param
    assert_response :success
  end

  test "should update entry" do
    login_as :dave
    put :update, :id => @entry.to_param, :entry => @update
    assert_redirected_to entry_path(assigns(:entry))
  end
  
  # Log in as dave and try to update admin's entries.
  test "should not update entry" do
    login_as :mike
    put :update, :id => @entry.to_param, :entry => @update
    assert_redirected_to entries_url
  end

  test "should destroy entry" do
    login_as :dave
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => @entry.to_param
    end

    assert_redirected_to entries_path
  end
  
  test "should not destroy entry" do
    login_as :mike
    assert_difference('Entry.count', 0) do
      delete :destroy, :id => @entry.to_param
    end
    
    assert_redirected_to entries_url
  end
  
  # Markdown formatting tests.
  test "markdown entry should contain html table markup" do
    login_as :mike
    get :index
    assert_response :success
    id = entries(:mike_markdown_table).id
    assert_select("##{id} .text table")
  end
  
  test "markdown entry should contain html heading markup" do
    login_as :mike
    get :index
    assert_response :success
    id = entries(:mike_markdown_headings).id
    assert_select("##{id} .text h1")
    assert_select("##{id} .text h2")
    assert_select("##{id} .text h3")
    assert_select("##{id} .text h4")
    assert_select("##{id} .text h5")
    assert_select("##{id} .text h6")
  end
  
  test "markdown entry should contain blockquote markup" do
    login_as :mike
    get :index
    assert_response :success
    id = entries(:mike_markdown_blockquote).id
    assert_select("##{id} .text blockquote")
  end
  
  test "markdown entry should contain unordered list markup" do
    login_as :mike
    get :index
    assert_response :success
    id = entries(:mike_markdown_unordered_list).id
    assert_select("##{id} .text ul")
  end
  
  test "markdown entry should contain ordered list markup" do
    login_as :mike
    get :index
    assert_response :success
    id = entries(:mike_markdown_ordered_list).id
    assert_select("##{id} .text ol")
  end

  test "markdown entry should contain division markup" do
    login_as :mike
    get :index
    assert_response :success
    id = entries(:mike_markdown_div).id
    assert_select("##{id} .text div")
  end

end
