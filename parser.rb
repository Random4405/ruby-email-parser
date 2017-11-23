require 'sidekiq'
require 'pg'
require 'active_record'

require_relative 'models/email'
require_relative 'models/key'
require_relative 'lib/custom_email_parser'
require_relative 'lib/dialog'
require_relative 'lib/interface'
require_relative 'workers/keys_worker'

interface = Interface.new
interface_elements = %w[ logo license menu ]
interface_elements.each do |elem|
  interface.draw_empty_line
  interface.send("draw_#{elem}")
end

case gets.chomp.to_i
when 1
  CustomEmailParser.new.process_emails
when 2
  Email.to_csv
when 3
  Dialog.generate_keys
else
  Dialog.goodbye
end
