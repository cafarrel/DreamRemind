class Category < ActiveRecord::Base
  has_many :reminder
  has_many :user_categories
  has_many :users, :through => :user_categories
           
end
