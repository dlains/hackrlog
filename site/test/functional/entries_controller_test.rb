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

  test "authorized user should get index" do
    login_as(:dave)
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
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
  
  test "authorized user should create entry" do
    login_as(:dave)
    assert_difference('Entry.count') do
      post :create, :entry => @update
    end

    assert_redirected_to entries_url
  end

  test "authorized user should create entry with tags" do
    login_as(:dave)
    assert_difference('Entry.count') do
      post :create, {:tags => "Ruby", :entry => @update_with_tags}
    end
    
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not create entry" do
    logout
    post :create, entry: @update
    assert_redirected_to login_url
  end
  
  test "authorized owner should show entry" do
    login_as(:dave)
    get :show, id: @entry
    assert_response :success
  end

  test "authorized non-owner should not show entry" do
    login_as :dave
    get :show, :id => entries(:mike_markdown_table).id
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not show entry" do
    logout
    get :show, id: @entry
    assert_redirected_to login_url
  end
  

  test "authorized owner should get edit" do
    login_as(:dave)
    get :edit, id: @entry
    assert_response :success
  end

  test "authorized non-owner should not get edit" do
    login_as(:mike)
    get :edit, id: @entry
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not get edit" do
    logout
    get :edit, id: @entry
    assert_redirected_to login_url
  end
  
  test "authorized user should update entry" do
    login_as(:dave)
    put :update, id: @entry, entry: @update
    assert_redirected_to entry_path(assigns(:entry))
  end
  
  test "authorized non-owner should not update entry" do
    login_as(:mike)
    put :update, id: @entry, entry: @update
    assert_redirected_to entries_url
  end

  test "unauthorized user should not update entry" do
    logout
    put :update, id: @entry, entry: @update
    assert_redirected_to login_url
  end
  
  test "authorized owner should destroy entry" do
    login_as(:dave)
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => @entry.to_param
    end

    assert_redirected_to entries_path
  end
  
  test "authorized non-owner should not destroy entry" do
    login_as(:mike)
    assert_difference('Entry.count', 0) do
      delete :destroy, :id => @entry.to_param
    end
    
    assert_redirected_to entries_url
  end
  
  test "unauthorized user should not destroy entry" do
    logout
    assert_difference('Entry.count', 0) do
      delete :destroy, id: @entry
    end
    
    assert_redirected_to login_url
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
