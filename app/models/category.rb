# == Schema Information
# Schema version: 20100531054318
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  has_many :reminder
  has_many :user_categories
  has_many :users, :through => :user_categories
           
end
