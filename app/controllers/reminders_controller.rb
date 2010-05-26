class RemindersController < ApplicationController
  
  before_filter :login_required
  before_filter :reminder_authorization_required, :only => ['new', 'index', 'show', 'edit', 'create', 'update', 'destroy']
  
  # GET /reminders
  # GET /reminders.xml
  def index
    @user = User.find_by_username(params[:user_id])
    @reminders = Reminder.find(:all, :conditions => ["user_id = ?", @user.id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reminders }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show
    @reminder = Reminder.find(params[:id])
    @category = Category.find(:first, :conditions => ["id = ?", @reminder.category_id])

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
    @reminder = Reminder.find(params[:id])
    @reminder.destroy
    @user = User.find_by_username(params[:user_id])
    
    flash[:success] = 'Reminder successfully deleted.'

    respond_to do |format|
      format.html { redirect_to user_path(@user) }
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
end
