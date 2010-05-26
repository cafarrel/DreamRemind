class CategoriesController < ApplicationController
  
  before_filter :login_required
  before_filter :category_authorization_required, :only => ['new', 'index', 'show', 'edit', 'create', 'update', 'destroy']  
  
  def new
    @category = Category.new
    @user = User.find_by_username(params[:user_id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def index
    @user = User.find_by_username(params[:user_id])
    
    @categories = Category.find(:all)
    @user_categories = @user.categories
  end
  
  def create
    @user = User.find_by_username(params[:user_id])
    
    @category = Category.new(params[:category])
    @existing_category = Category.find_by_name(@category.name)
    
    if @existing_category.nil?
      @category.save
      UserCategory.create(:category_id => @category.id, :user_id => @user.id)
      flash[:success] = "Category successfully saved!"
    else
      if !UserCategory.record_exists?(@existing_category.id, @user.id)      
        UserCategory.create(:category_id => @existing_category.id, :user_id => @user.id)
        flash[:success] = "Category successfully saved!"
      else
        flash[:error] = "You already have that category!"
      end
    end
                   
    redirect_to user_categories_path(@user)
    
  end
  
  def destroy
    @user = User.find_by_username(params[:user_id])
    @category_mapping = UserCategory.find_by_category_id_and_user_id(params[:id], @user.id)
    
    @category_mapping.destroy
    
    flash[:success] = "Category successfully deleted!"
    
    respond_to do |format|
      format.html { redirect_to user_categories_path(@user) }
      format.xml  { head :ok }
    end
  end
  
  def category_authorization_required
    if !allowed_to_view_category_action?
      flash[:error] = "You are not allowed to access that page!"      
      redirect_to_stored
      return
    end
  end     
  
  def allowed_to_view_category_action?    
    return current_user.id.to_s == params[:user_id] || current_user.username == params[:user_id]
  end    
  
end
