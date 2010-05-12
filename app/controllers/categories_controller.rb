class CategoriesController < ApplicationController
  
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
      flash[:notice] = "Category successfully saved!"
    else
      if !UserCategory.record_exists?(@existing_category.id, @user.id)      
        UserCategory.create(:category_id => @existing_category.id, :user_id => @user.id)
        flash[:notice] = "Category successfully saved!"
      else
        flash[:notice] = "You already have that category!"
      end
    end
                   
    redirect_to user_categories_path(@user)
    
  end
  
end
