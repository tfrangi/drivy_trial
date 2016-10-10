require "json"
require "awesome_print"
require 'Date'

# your code
def data 
	file = File.read('data.json')
	data = JSON.parse(file)
end

def cars
	data['cars']
end

def rental_price rental
	car = cars[(rental['car_id']-1)]
	t_price = time_price car, rental['start_date'], rental['end_date']
	d_price = distance_price car, rental['distance']

	t_price + d_price
end

def time_price car, start_date, end_date
	nb_days = (Date.parse(end_date) - Date.parse(start_date)).to_i
	car['price_per_day'] * (nb_days + 1)
end

def distance_price car, distance
	car['price_per_km'] * distance
end



##############

rentals = data['rentals']

output = {rentals: []}

rentals.each do |rental|
	output[:rentals] << {id: rental['id'], price: rental_price(rental)}
end

ap output
File.open("sample.json", "wb") { |file| file.puts JSON.pretty_generate(output) }
