class Notifications < ActionMailer::Base
  

  def forgot_password(to, username, new_pass, sent_at = Time.now)
    @subject = 'Birthday Reminder - New Password Request'
    @body['login'] = username
    @body['pass'] = new_pass
    @recipients = to
    @from = 'support@bdayreminder.com'
    @sent_on = sent_at
    @headers = {}
  end

end
