module TagsHelper

  # Enhance the standard check_box_tag helper to allow for different name and id values.
  def tags_check_box_tag(name, id, value = "1", checked = false, options = {})
    html_options = { "type" => "checkbox", "name" => name, "id" => id, "value" => value }.update(options.stringify_keys)
    html_options["checked"] = "checked" if checked
    tag :input, html_options
  end
  
end
