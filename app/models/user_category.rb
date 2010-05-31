# == Schema Information
# Schema version: 20100531054318
#
# Table name: user_categories
#
#  id          :integer         not null, primary key
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean
#

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
  
  def self.update_active_flags
    find(:all).each do |mapping|
      mapping.active = true
      mapping.save
    end
  end
  
  def self.record_exists?(category_id, user_id)
    !find_by_category_id_and_user_id(category_id, user_id).nil?    
  end
  
  
end
