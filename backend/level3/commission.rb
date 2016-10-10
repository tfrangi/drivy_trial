class Commission
	def initialize rental
		@rental = rental
		@total = (@rental.price * 0.3).to_i
		@insurance = (@total * 0.5).to_i
		@assistance = @rental.nb_days * 100
		@drivy = @total - @insurance - @assistance
	end

	def to_hash
		{
			insurance_fee:  @insurance,
			assistance_fee: @assistance,
			drivy_fee: @drivy
		}
	end
end