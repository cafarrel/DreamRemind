task :cron => :environment do
  Reminder.send_reminders
end