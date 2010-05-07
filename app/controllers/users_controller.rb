class UsersController < ApplicationController
  
  before_filter :login_required, :only => ['welcome', 'change_password', 'hidden', 'show', 'edit']
  before_filter :authorization_required, :only => ['show', 'edit', 'update', 'destroy']
  
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
    #redirect_to :action => 'login'
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
    @user = User.find_by_identifier(params[:id])
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
    @user = nil
    @reminders = nil
    
    if logged_in?
      @user = current_user
      @reminders = Reminder.find(:all, :conditions => ["user_id = ?", @user.id])  
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show    
    @user = nil
    @reminders = nil
    
    if logged_in?
      @user = User.find_by_identifier(params[:id])
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
    @user = User.find_by_identifier(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
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
    @user = User.find_by_identifier(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])        
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else      
        flash[:notice] = 'Failed to update user.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find_by_identifier(params[:id])
    @user.destroy

    session[:user] = nil

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end  
     
  def skip_password_validation(user)
    user.password = user.password_confirmation = '-' * 5
  end
end
