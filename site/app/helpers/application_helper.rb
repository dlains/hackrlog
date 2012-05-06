module ApplicationHelper

  def owners
    hacker = Hacker.find(session[:hacker_id])
    if hacker.name != ''
      if hacker.name.end_with?('s')
        "#{hacker.name}'"
      else
        "#{hacker.name}'s"
      end
    else
      "Your"
    end
  end

  def tag_usage(hacker)
    @tags = Tag.tag_usage(hacker)
  end

  def get_datetime_for_entry(entry)
    hacker = Hacker.find(session[:hacker_id])
    entry.updated_at.in_time_zone(hacker.time_zone).strftime('%b. %d, %Y %I:%M %p')
  end

end
