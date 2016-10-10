class JsonData
	attr_reader :data

	def initialize
		@data ||= JSON.parse(File.read('data.json'))
	end

	def self.find resource
		self.new.data[resource]
	end
end