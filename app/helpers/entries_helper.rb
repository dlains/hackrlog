module EntriesHelper

  # Preprocess code blocks with Albino - Pygments.
  class HTMLAlbino < Redcarpet::Render::HTML
    def block_code(code, language)
      Albino.colorize(code, language)
    end
  end
  
  # Only need one instance of the markdown processor.
  @@markdown = Redcarpet::Markdown.new(HTMLAlbino, fenced_code_blocks: true, autolink: true, no_intra_emphasis: true)
  
  def format_content(entry)
    return @@markdown.render entry.content
  end
  
  def tag_values(entry)
    if !entry.tags.empty?
      entry.tags.join(" ")
    elsif session.has_key?(:current_tags)
      session[:current_tags]
    end
  end
  
end
