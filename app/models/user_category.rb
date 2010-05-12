class UserCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  
  def self.populate_initial_categories(user_id)
    create(:category_id => 1, :user_id => user_id)
    create(:category_id => 2, :user_id => user_id)
    create(:category_id => 3, :user_id => user_id)
    create(:category_id => 4, :user_id => user_id)
    create(:category_id => 5, :user_id => user_id)  
  end
  
  def self.record_exists?(category_id, user_id)
    !find_by_category_id_and_user_id(category_id, user_id).nil?    
  end
  
  
end
