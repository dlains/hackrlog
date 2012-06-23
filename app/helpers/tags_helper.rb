module TagsHelper

  # TODO: Remove!
  def add_tag_mini_form
    @new_tag = Tag.new
    render :partial => 'tags/form'
  end

  # Should the tag check box be checked?
  def checked?(tag)
    if params.has_key?(:id)
      params[:id] == tag.id.to_s
    elsif params.has_key?(:tag_ids)
      params[:tag_ids].include?(tag.id.to_s)
    else
      false
    end
  end
  
  # Enhance the standard check_box_tag helper to allow for different name and id values.
  def tags_check_box_tag(name, id, value = "1", checked = false, options = {})
    html_options = { "type" => "checkbox", "name" => name, "id" => id, "value" => value }.update(options.stringify_keys)
    html_options["checked"] = "checked" if checked
    tag :input, html_options
  end
  
end
