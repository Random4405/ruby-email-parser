require 'active_record'
require 'pg'

class Key < ActiveRecord::Base
  establish_connection(
    adapter:  'postgresql',
    database: 'email_parser_development',
    pool: 200
  )
end
