require 'sidekiq'
require 'active_record'
require_relative 'models/email'
require_relative 'models/key'
require_relative 'lib/custom_email_parser'
require 'colorize'

loop do
  first_emails = Email.where.not(score: nil).count
  sleep 20
  full_emails = Email.where.not(score: nil).count
  speed = (full_emails - first_emails) / 20.0
  if speed < 1
    if Keys.where(status: true).count > 10
      CustomEmailParser.new.process_emails
      puts "[#{Time.now.strftime('%T')}] 5000 emails added".colorize(:yellow)
    else
      puts "[#{Time.now.strftime('%T')}] Not enouht keys".colorize(:red)
    end
  else
    puts "[#{Time.now.strftime('%T')}] Emails in processing".colorize(:green)
  end
end
