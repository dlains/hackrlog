module EntriesHelper

  # Preprocess code blocks with Albino - Pygments.
  class HTMLAlbino < Redcarpet::Render::HTML
    def block_code(code, language)
      Albino.colorize(code, language)
    end
  end
  
  # Only need one instance of the markdown processor.
  @@markdown = Redcarpet::Markdown.new(HTMLAlbino, :fenced_code_blocks => true, :autolink => true)
  
  def format_content(entry)
    return @@markdown.render entry.content
  end
  
  def hackers_tags
    Tag.where("hacker_id = ?", session[:hacker_id])
  end
  
  def tag_values(entry)
    if !entry.tags.empty?
      entry.tags.join(", ")
    elsif session.key?(:current_tags)
      session[:current_tags]
    end
  end
  
  # Easy create or update submit buttons for the entries/_form.html.erb form
  def entry_submit_tag(entry)
    if(entry.new_record?)
      submit_tag('Create') + submit_tag('Reset', type: 'reset')
    else
      submit_tag('Update')
    end
  end
  
end
