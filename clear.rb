require 'pg'
require 'active_record'

require_relative 'models/email'
require_relative 'models/key'
require 'byebug'

require 'csv'

CSV.foreach('shops_emails.csv', :headers => false) do |row|
  emails = row[1].delete('{').delete('}').split(',')
  emails.each do |email|
    Email.create(email: email, base_domain: row[0])
  end
end

puts 'Done!'
