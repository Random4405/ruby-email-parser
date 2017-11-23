require 'active_record'
require 'pg'
require 'csv'

class Email < ActiveRecord::Base
  establish_connection(
    adapter:  'postgresql',
    database: 'email_parser_development',
    pool: 200
  )

  def self.to_csv
    attributes = %w{email}
    CSV.open("emails.csv", "wb", headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
