module EntriesHelper

  # Preprocess code blocks with Albino - Pygments.
  class HTMLWithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      # TODO: Check the end of Railscasts #207 for caching tips if needed.
      Pygments.highlight(code, lexer: language)
    end
  end

  def format_content(text)
    renderer = HTMLWithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      stikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
  
  def tag_values(entry)
    if !entry.tags.empty?
      entry.tags.join(" ")
    elsif session.has_key?(:current_tags)
      session[:current_tags]
    end
  end
end
