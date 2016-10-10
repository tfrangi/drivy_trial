class Rental
	attr_reader :id, :history, :options, :deductible_reduction
	attr_accessor :distance

	def initialize id, car_id, start_date, end_date, distance, deductible_reduction
		@id = id
		@car_id = car_id
		self.start_date = start_date
		self.end_date = end_date
		@distance = distance
		self.options = deductible_reduction
	end

	def to_hash
		{
			id: @id,
			price: price,
			options: options
		}
	end

	def self.find id
		rental = JsonData.find('rentals').select{|rental| rental['id'] == id}.first
		self.new(rental['id'], rental['car_id'], rental['start_date'], rental['end_date'], rental['distance'], rental['deductible_reduction'])
	end

	def start_date= date
		@start_date = Date.parse(date)
	end

	def end_date= date
		@end_date = Date.parse(date)
	end

	def options= deductible_reduction
		@deductible_reduction = deductible_reduction
		@options = {deductible_reduction: deductible_reduction ? nb_days * 400 : 0}
	end

	def nb_days
		(@end_date - @start_date).to_i + 1
	end

	def car
		Car.find @car_id
	end

	def price
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

	def push_history actions, commission
		@history ||= []
		@history << {commission: commission, actions: actions}
	end

	def update new_data
		new_data.each do |k, v|
			if ['distance', 'start_date', 'end_date'].include? k
				self.send("#{k}=", v)
			end
		end
		self.options = deductible_reduction
		calculate_actions
	end

	def calculate_actions
		commission = Commission.new self
		Action.calc_all(commission)
	end
end