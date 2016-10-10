class Action
	CONTRACTORS = ['driver', 'owner', 'insurance', 'assistance', 'drivy'].freeze

	def initialize who, commission
		@who = who
		@commission = commission
		@rental = commission.rental
	end

	def to_hash
		{
			who: @who,
			type: type,
			amount: amount
		}
	end

	def amount
		case @who
		when 'driver'
			@rental.price + @rental.options[:deductible_reduction]
		when 'owner'
			@rental.price - @commission.total
		when 'insurance'
			@commission.insurance
		when 'assistance'
			@commission.assistance
		when 'drivy'
			@commission.drivy + @rental.options[:deductible_reduction]
		end
	end

	def type
		@type unless @type.nil?
		@type = @who == 'driver' ? 'debit' : 'credit'
	end

	def self.calc_all commission
		actions = []
		CONTRACTORS.each do |name|
			action = self.new name, commission
			actions << action.to_hash
		end
		actions
	end
end