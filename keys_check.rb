require 'active_record'
require_relative 'models/key'
require_relative 'models/email'
require 'byebug'

debugger
# Key.all.map {|k| k.status = true; k.save}

# keys = [
#   '61d42c8aa200cd80babbbcfc52fe1628',
#   'a44b3fd5f953f760d16f978916b3d6af',
#   '6dbf4cff5aa9076bf929f62967ee0303',
#   'bced16f22bd84e5107ea8218d0226a6f',
#   'b85cca11a658d4254f7c0d21b1552c02',
#   '7e6ea516ca7d13fabc6f13922b4d128b',
#   '83020d74c1c1a7f1055c8c8956ba6b3d',
# ]
# keys.each do |key|
#   Key.create(
#     key: key,
#     status: true
#   )
# end

require 'csv'

CSV.foreach('last-emails.csv', :headers => true) do |row|
  Email.create!(row.to_hash)
end
