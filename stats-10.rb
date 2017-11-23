require 'active_record'
require_relative 'models/key'
require_relative 'models/email'
require 'colorize'

loop do
  all_emails = Email.count
  first_emails = Email.where.not(score: nil).count
  sleep 20
  full_emails = Email.where.not(score: nil).count
  estimated_time = (all_emails / ((full_emails - first_emails)/20.0)) / 60
  estimated_time = estimated_time.round unless estimated_time.infinite?
  print "Speed: #{((full_emails - first_emails)/20.0).to_s.colorize(:green)} emails/s | " \
  "Estimated time: #{estimated_time.to_s.colorize(:yellow)} minutes \r"
end


