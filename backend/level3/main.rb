require "json"
require "awesome_print"
require 'Date'

require './json_data'
require './car'
require './commission'
require './rental'
# your code



output = {rentals: []}
JsonData.find('rentals').each do |rental|
	rental = Rental.find rental['id']
	commission = Commission.new rental
	output[:rentals] << rental.to_hash.merge(commission: commission.to_hash)
end


ap output
File.open("sample.json", "wb") { |file| file.puts JSON.pretty_generate(output) }


