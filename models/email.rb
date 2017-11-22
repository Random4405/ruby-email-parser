require 'active_record'
require 'pg'

class Email < ActiveRecord::Base
  establish_connection(
    adapter:  'postgresql',
    database: 'email_parser_development',
    pool: 50
  )

  def self.to_csv
    attributes = %w{id email score}
    CSV.open("emails.csv", "wb", headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
