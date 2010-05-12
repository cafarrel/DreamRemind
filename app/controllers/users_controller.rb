class UsersController < ApplicationController
  
  before_filter :login_required, :only => ['change_password', 'show', 'edit', 'update', 'destroy']
  before_filter :user_authorization_required, :only => ['show', 'edit', 'update', 'destroy']
  
  def login
    
    if request.post?
      if session[:user] = User.authenticate(params[:user][:username], params[:user][:password])
        flash[:notice] = "Login Successful"
        #redirect_to username_path(current_user.username)
        redirect_to current_user
      else
        flash[:notice] = "Login Unsuccessful"
      end
    end
  end
  
  def logout
    session[:user] = nil    
    flash[:notice] = "Successfully Logged Out"
    redirect_to :root, :action => 'index'
    #redirect_to :root, :controller => 'user', :action => 'index'
  end
  
  def forgot_password
    if request.post?
      u = User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        flash[:notice] = "A new password has been sent to " << u.email
        redirect_to login_path
      else
        flash[:notice] = "Couldn't send password"
      end
    end
  end

  def change_password    
    @user = User.find_by_username(params[:id])
    puts @user.inspect
    if request.post? || request.put?    
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:notice] = "Password Successfully Changed!"
        redirect_to edit_user_path
      end
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    end
  end
  
  # GET /users
  # GET /users.xml
  def index    
    if logged_in?
      redirect_to current_user
    else    
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show    
    @user = nil
    @reminders = nil
    
    if logged_in?
      @user = User.find_by_username(params[:id])
      @reminders = Reminder.find(:all, :conditions => ["user_id = ?", @user.id])      
    end    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit    
    @user = User.find_by_username(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save and @user.send_registration_notification
        UserCategory.populate_initial_categories(@user.id)        
        flash[:notice] = 'User was successfully created.'
        session[:user] = @user
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find_by_username(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])        
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else      
        #flash[:notice] = 'Failed to update user.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find_by_username(params[:id])
    @user.destroy

    session[:user] = nil

    respond_to do |format|
      format.html { redirect_to :root }
      format.xml  { head :ok }
    end
  end  
end
