class CategoryController < ApplicationController
  
  def new
    @category = Category.new
    if request.post?
      if @category.save
        flash[:notice] = "Category successfully saved!"
        redirect_to edit_user_path
      end
    end
  end
  
  def index
    @categories = Category.find(:all)
  end
  
end
