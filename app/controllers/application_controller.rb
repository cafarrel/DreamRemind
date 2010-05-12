# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password  
  
    def login_required
    if session[:user]
      return true
    end
    flash[:notice] = 'Please login to continue'
    session[:return_to] = request.request_uri
    redirect_to login_path
    return false
  end
  
  def current_user
    return session[:user]
  end  
  helper_method :current_user
  
  def has_reminders?
    return current_user.reminders.size > 0
  end
  helper_method :has_reminders?
  
  def logged_in?
    return current_user != nil
  end
  helper_method :logged_in?
  
  def user_authorization_required
    if !allowed_to_view_user_action?
      flash[:notice] = "You are not allowed to access that page!"      
      redirect_to_stored
      return
    end
  end
  
  def reminder_authorization_required
    if !allowed_to_view_reminder_action?
      flash[:notice] = "You are not allowed to access that page!"      
      redirect_stored
      return
    end
  end
     
  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'users', :action=>'index'
    end
  end
  
  def redirect_back
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to :controller => 'users', :action => 'index'
  end
  
  def allowed_to_view_user_action?    
    return current_user.id.to_s == params[:id] || current_user.username == params[:id]
  end   
  
  def allowed_to_view_reminder_action?
    return current_user.id.to_s == params[:user_id] || current_user.username == params[:user_id]
  end

end
