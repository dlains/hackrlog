module TagSetsHelper
  
  def tag_set_action(tag_set)
    if session.key?(:tag_set_id) && session[:tag_set_id] == tag_set.id
      content_tag(:td, link_to('D', deactivate_tag_set_path(tag_set), remote: true, method: :get, title: "Deactivate"))
    else
      content_tag(:td, link_to('A', activate_tag_set_path(tag_set), remote: true, method: :get, title: "Activate"))
    end
  end
  
end
