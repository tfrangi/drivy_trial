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
			amount: amount.abs
		}
	end

	def amount
		return @amount unless @amount.nil?
		
		@amount = case @who
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
		@amount -= calc_history
	end

	def type
		calc_history
		if @last_story.nil?
			@type = @who == 'driver' ? 'debit' : 'credit'
		else
			if amount < 0
				if @last_story[:type] == 'credit'
					@type = 'debit'
				elsif @last_story[:type] == 'debit'
					@type = 'credit'
				end
			else
				@type = @last_story[:type]
			end
		end
	end

	def calc_history
		return @sum_history unless @sum_history.nil?
		
		sum = 0
		unless @rental.history.nil?
			@rental.history.each do |story|
				story = story[:actions].select{|action| action[:who] == @who}.first
				unless story.nil?
					sum += story[:amount]
				end
				@last_story = story
			end
			@sum_history = sum
		end

		sum
	end

	def self.calc_all commission
		actions = []
		CONTRACTORS.each do |name|
			action = self.new name, commission
			actions << action.to_hash
		end
		commission.rental.push_history actions, commission
		actions
	end
end