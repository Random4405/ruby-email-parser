require 'active_record'
require_relative '../models/email'
require_relative '../workers/email_worker'

class CustomEmailParser
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def process_emails
    Email.where(score: nil).each do |email|
      ::EmailWorker.perform_async(email_id: email.id) if is_a_valid_email?(email.email)
    end
  end

  def is_a_valid_email?(email)
    (email =~ VALID_EMAIL_REGEX)
  end
end
