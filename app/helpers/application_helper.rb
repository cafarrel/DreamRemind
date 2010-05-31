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
      html = content_tag(:div, content_tag(:div, value, :class =>key) << '<br />', :id => "flash-div")
      html << content_tag(:script, "setTimeout(\"new Effect.Fade('flash-div');\", 10000);", :type => "text/javascript")      
    end
  
    html
  end
  
  def sort_link(title, column)    
    sort_dir = params[:dir] == 'down' ? 'up' : 'down'      
    
    arrow(column) << link_to(title, request.parameters.merge( {:col => column, :dir => sort_dir} ))
  end
  
  def arrow(column)
    if (params[:col].to_s == column.to_s)
      #params[:dir]== "down" ? "&#8595;" : "&#8593;"
      params[:dir]== "down" ? "&#8681;" : "&#8679;"
    else
      ""
    end
  end 
  
  def greeting
    greetings = ['Hi', 'Hello', 'Welcome', 'Greetings', 'Hey']
    greetings[rand(greetings.size)]
  end
  
  def view_link(title, type)    
    link_to(title, request.parameters.merge( {:view => type} ))
  end
end
