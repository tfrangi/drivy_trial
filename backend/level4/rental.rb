class Rental
	attr_reader :nb_days
	
	def initialize id, car_id, start_date, end_date, distance, deductible_reduction
		@id = id
		@car_id = car_id
		@start_date = Date.parse(start_date)
		@end_date = Date.parse(end_date)
		@nb_days = (@end_date - @start_date).to_i + 1
		@distance = distance

		@deductible_reduction = deductible_reduction ? @nb_days * 400 : 0
	end

	def to_hash
		{
			id: @id,
			price: price,
			options: {
				deductible_reduction: @deductible_reduction
			},
			commission: commission,
		}
	end

	def self.find id
		rental = JsonData.find('rentals').select{|rental| rental['id'] == id}.first
		self.new(rental['id'], rental['car_id'], rental['start_date'], rental['end_date'], rental['distance'], rental['deductible_reduction'])
	end

	def car
		@car ||= Car.find @car_id
	end

	def price
		@price unless @price.nil?

		time_price + distance_price
	end

	def time_price nb_days = nil
		nb_days = self.nb_days if nb_days.nil?
		car_price = car.price_per_day
		case nb_days
		when 1
			car_price
		when 2..4
			(car_price + (nb_days - 1) * car_price * 0.9 ).to_i
		when 5..10
			(time_price(4) + (nb_days - 4) * car_price * 0.7).to_i
		else
			(time_price(10) + (nb_days - 10) * car_price * 0.5).to_i
		end
	end

	def distance_price
		car.price_per_km * @distance
	end

	def commission
		total = (price * 0.3).to_i
		insurance = (total * 0.5).to_i
		assistance = @nb_days * 100
		drivy = total - insurance - assistance
		{
			insurance_fee:  insurance,
			assistance_fee: assistance,
			drivy_fee: drivy
		}
	end
end