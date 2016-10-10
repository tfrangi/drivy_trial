require "json"
require "awesome_print"
require 'Date'

require './json_data'
require './action'
require './car'
require './commission'
require './rental'

# your code

###############

output = {rentals: []}
JsonData.find('rentals').each do |rental|
	rental = Rental.find rental['id']
	commission = Commission.new rental
	output[:rentals] << {id: rental.id}.merge(actions: Action.calc_all(commission))
end


ap output
File.open("sample.json", "wb") { |file| file.puts JSON.pretty_generate(output) }


