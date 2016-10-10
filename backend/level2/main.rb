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
	nb_days = nb_days rental['start_date'], rental['end_date']
	t_price = time_price car, nb_days
	ap "===="
	ap t_price
	d_price = distance_price car, rental['distance']

	(t_price + d_price).to_i
end

def nb_days start_date, end_date
	(Date.parse(end_date) - Date.parse(start_date)).to_i + 1
end

def time_price car, nb_days
	price = car['price_per_day']
	case nb_days
	when 1
		price
	when 2..4
		(price + (nb_days - 1) * price * 0.9 ).to_i
	when 5..10
		(time_price(car, 4) + (nb_days - 4) * price * 0.7).to_i
	else
		(time_price(car, 10) + (nb_days - 10) * price * 0.5).to_i
	end
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
