UserCategory.find(:all).each do |uc|
  uc.active = true
  uc.save
end