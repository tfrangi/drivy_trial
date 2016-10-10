require "json"
require "awesome_print"
require 'Date'

require './json_data'
require './car'
require './rental'

# your code


output = {rentals: []}
JsonData.find('rentals').each do |rental|
	rental = Rental.find rental['id']
	output[:rentals] << rental.to_hash
end


ap output
File.open("sample.json", "wb") { |file| file.puts JSON.pretty_generate(output) }


