class Car
	attr_reader :id, :price_per_day, :price_per_km

	def initialize id, price_per_day, price_per_km
		@id = id
		@price_per_day = price_per_day
		@price_per_km = price_per_km
	end

	def self.find id
		car = JsonData.find('cars').select{|car| car['id'] == id}.first
		self.new(car['id'], car['price_per_day'], car['price_per_km'])
	end
end