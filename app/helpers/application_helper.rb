# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper    
  def pretty_date(date)    
    if date.to_s[0..3] == '0001'
      return date.strftime("%B %d")
    end
    return date.strftime("%B %d, %Y")
  end
  
  def show_flash_message
    html = ''
    flash.each do |key, value|  
      html = content_tag(:div, value, :class => key, :id => "flash-div")
      html << content_tag(:script, "setTimeout(\"new Effect.Fade('flash-div');\", 10000);", :type => "text/javascript")  
    end
  
    html
  end  
end
