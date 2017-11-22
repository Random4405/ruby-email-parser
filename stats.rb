require 'active_record'
require_relative 'models/key'
require_relative 'models/email'
require 'colorize'

loop do
  first_emails = Email.where.not(score: nil).count
  all_emails = Email.count
  new_keys = Key.where(status: true).count 
  sleep 5
  full_emails = Email.where.not(score: nil).count
  print "Available keys: #{new_keys.to_s.colorize(:green)} | " \
    "Validated emails: #{full_emails.to_s.colorize(:green)}/#{all_emails} " \
    "(#{(full_emails * 100)/all_emails}%) | " \
    "Need keys: #{(((all_emails - full_emails)/250) - new_keys).to_s.colorize(:red)} | " \
    "Estimated time: #{((all_emails / ((full_emails - first_emails)/5.0)) / 60).round.to_s.colorize(:yellow)} minutes | " \
    "Speed: #{((full_emails - first_emails)/5.0).to_s.colorize(:green)} emails/s\r"
end


