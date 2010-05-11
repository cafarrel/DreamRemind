class Category < ActiveRecord::Base
  has_many :reminder
  belongs_to :user
end
