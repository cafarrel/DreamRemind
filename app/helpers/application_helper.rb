# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper    
  def pretty_date(date)
    return date.strftime("%B %d, %Y")
  end
end
