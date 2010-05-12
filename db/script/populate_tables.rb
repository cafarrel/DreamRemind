User.find(:all).each do |u|
  UserCategory.create(:category_id => 1, :user_id => u.id)
  UserCategory.create(:category_id => 2, :user_id => u.id)
  UserCategory.create(:category_id => 3, :user_id => u.id)
  UserCategory.create(:category_id => 4, :user_id => u.id)
  UserCategory.create(:category_id => 5, :user_id => u.id)  
end

