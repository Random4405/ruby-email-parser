require 'rest-client'
require 'json'
require_relative '../models/email'

class EmailWorker
  include Sidekiq::Worker
  def perform(*args)
    email = Email.find(args[0]['email_id'])
    request_result_for(email)
  end

  def key
    @key ||= Key.where(status: true).first
  end

  def disable_key
    key.status = false
    key.save
    @key = nil
    KeysWorker.perform_async if Key.where(status: true).count < 4
  end

  def request_result_for(email)
    url='http://apilayer.net/api/check'
    result = RestClient.get(url, params: {
      access_key: key.key, email: email[:email], smtp: 1, format: 1
    })
    if hash_result(result)["success"].eql?(false)
      disable_key
      request_result_for(email)
    end
    save_to_db(email, result)
  end

  def hash_result(result)
    JSON.parse(result.body)
  end

  def save_to_db(email, result)
    hash = hash_result(result)
    email.did_you_mean = hash['did_you_mean']
    email.user = hash['user']
    email.domain = hash['domain']
    email.format_valid = hash['format_valid']
    email.mx_found = hash['mx_found']
    email.smtp_check = hash['smtp_check']
    email.catch_all = hash['catch_all']
    email.role = hash['role']
    email.disposable = hash['disposable']
    email.free = hash['free']
    email.score = hash['score']
    email.save
    puts "#{email.email} updated"
  end
end
