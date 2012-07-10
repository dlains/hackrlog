module ApplicationHelper

  # Get a name to use for the page title.
  def owners
    if current_user.name != ''
      if current_user.name.end_with?('s')
        "#{current_user.name}'"
      else
        "#{current_user.name}'s"
      end
    else
      "Your"
    end
  end

  # Get the tags needed for the sidebar.
  def get_updated_tag_list
    if is_filtered?
      @tags = Tag.filtered_hacker_tags(session[:filter], current_user.id)
    else
      @tags = Tag.current_hacker_tags(current_user.id)
    end
  end
  
  # Is the /entries page being filtered?
  def is_filtered?
    if session.has_key?(:filter)
      return session[:filter].length > 0
    else
      return false
    end
  end

  # Is the passed in tag supposed to be checked?
  def checked?(tag)
    if session.has_key?(:filter)
      session[:filter].include?(tag.id.to_s)
    else
      false
    end
  end

  def get_datetime_for_entry(entry)
    entry.updated_at.in_time_zone(current_user.time_zone).strftime('%b %d, %Y %I:%M %p')
  end

  # Add an <span class="error"> for form fields with errors.
  def form_field_error(object, attribute)
    if object.errors[attribute].any?
      content_tag(:span, object.errors[attribute].to_sentence, class: 'error')
    end
  end

end
