class RemindersController < ApplicationController
  
  before_filter :login_required
  before_filter :reminder_authorization_required, :only => ['new', 'index', 'show', 'edit', 'create', 'update', 'destroy']
  
  # GET /reminders
  # GET /reminders.xml
  def index
    @user = User.find_by_username(params[:user_id])
    @categories = UserCategory.find(:all, :conditions => ["user_id = ? AND active = ?", @user.id, true], :joins => :category, :order => "name")    
    
    @reminders = Hash.new
    @categories.each do |c|
     @reminders[c.category.id] = Reminder.find_all_by_user_id_and_category_id(@user.id, c.category_id) 
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reminders }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show
    @user = User.find_by_username(params[:user_id])
    @reminder = Reminder.find(params[:id])
    @category = Category.find(@reminder.category_id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reminders }
    end
  end

  # GET /reminders/new
  # GET /reminders/new.xml
  def new
    @reminder = Reminder.new    
    @user = User.find_by_username(params[:user_id])
    @categories = @user.categories

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  # GET /reminders/1/edit
  def edit
    @reminder = Reminder.find(params[:id])
    @categories = Category.find(:all)
    @user = User.find_by_username(params[:user_id])
  end

  # POST /reminders
  # POST /reminders.xml
  def create
    @user = User.find_by_username(params[:user_id])
    @reminder = Reminder.new(params[:reminder])

    respond_to do |format|
      if @reminder.save
        update_user_category_active_flag(@reminder, true)
        flash[:success] = 'Reminder was successfully created.'        
        format.html { redirect_to user_path(@user) }        
        #format.xml  { render :xml => @reminder, :status => :created, :location => @reminder }
      else
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reminders/1
  # PUT /reminders/1.xml
  def update
    @user = User.find_by_username(params[:user_id])
    @reminder = Reminder.find(params[:id])

    respond_to do |format|
      if @reminder.update_attributes(params[:reminder])
        flash[:success] = 'Reminder was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.xml
  def destroy
    @user = User.find_by_username(params[:user_id])    
    @reminder = Reminder.find(params[:id])
    
    update_user_category_active_flag(@reminder, false)
    
    @reminder.destroy
           
    flash[:success] = 'Reminder successfully deleted.'

    respond_to do |format|
      format.html { redirect_to_stored }
      #format.html { redirect_to user_path(@user) }
      format.xml  { head :ok }
    end
  end  
  
  def reminder_authorization_required
    if !allowed_to_view_reminder_action?
      flash[:error] = "You are not allowed to access that page!"      
      redirect_to_stored
      return
    end
  end
  
  def allowed_to_view_reminder_action?
    return current_user.id.to_s == params[:user_id] || current_user.username == params[:user_id]
  end
  
  private
  
  
  def update_user_category_active_flag(reminder, active_flag)
    @reminder_check = Reminder.find_all_by_category_id_and_user_id(reminder.category_id, reminder.user_id)
        
    if @reminder_check.size == 1
      @category_mapping = UserCategory.find_by_category_id_and_user_id(reminder.category_id, reminder.user_id)
      @category_mapping.active = active_flag
      @category_mapping.save    
    end    
  end
end
