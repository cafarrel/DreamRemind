class Notifications < ActionMailer::Base
  

  def forgot_password(to, username, new_pass, sent_at = Time.now)
    @subject = 'Dream Remind - New Password Request'
    @body['login'] = username
    @body['pass'] = new_pass
    @recipients = to
    @from = 'Dream Reminder'
    @sent_on = sent_at
    @headers = {}
  end
  
  def registration_notification(to, username, sent_at = Time.now)
    @subject = 'Welcome To Dream Remind!'
    @body['login'] = username    
    @recipients = to
    @from = 'Dream Remind'
    @sent_on = sent_at
    @headers = {}
  end

  def reminder_notification(to, username, reminder, sent_at = Time.now)
    @subject = 'Dream Remind - Reminder Notification'
    @body['login'] = username
    @body['reminder'] = reminder
    @recipients = to
    @from = 'Dream Remind'
    @sent_on = sent_at
    @headers = {}
  end

end
