require "json"
require "awesome_print"
require 'Date'

require './json_data'
require './action'
require './car'
require './commission'
require './rental'
# your code

output = {rental_modifications: []}
JsonData.find('rental_modifications').each do |rental_modification|

	rental = Rental.find rental_modification['rental_id']
	actions = rental.calculate_actions
	
	data_updated = rental_modification
	actions = rental.update data_updated

	output[:rental_modifications] << {
		id: rental_modification['id'], 
		rental_id: rental.id
	}.merge(actions: actions)
end

ap '========= out ========='
ap output
File.open("sample.json", "wb") { |file| file.puts JSON.pretty_generate(output) }


