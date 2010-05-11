class Reminder < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  
  def self.send_reminders
    # Checks for reminders that need to have emails sent out, and sends them
    due_reminders = Reminder.find(:all, :conditions => ["date = ?", Date.today])
    
    puts "Found #{due_reminders.size} reminder(s) to send out."
    
    due_reminders.each do |r|
      @user = User.find_by_id(r.user_id)
      
      puts "Sending reminder to " << @user.username
      
      Notifications.deliver_reminder_notification(@user.email, @user.username, r)
    end  
  end
end
